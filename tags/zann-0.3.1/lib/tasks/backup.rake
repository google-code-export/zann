namespace :db do
  namespace :backup do
    
    def connect
      puts "connecting..."
      database_yml = File.read File.join(RAILS_ROOT, 'config', 'database.yml') rescue nil
      environment = ENV['RAILS_ENV'] || 'development' # Mirror Rails' default.
      puts "establish connection..."
      ActiveRecord::Base.establish_connection(
        YAML.load(database_yml)[environment])
      tables = ActiveRecord::Base.connection.tables
        if tables.size > 0
          return true
        end
      return false
    end

    desc "Dump entire db."
    task :dump => :environment do 
      puts "dumping..."
      connect()
      backup_dir = File.join(RAILS_ROOT, 'db', 'backup')
      FileUtils.mkdir_p(backup_dir)
      FileUtils.chdir(backup_dir)
      backup_file = File.join(backup_dir, 
              "backup-#{Time.now.strftime('%Y%m%d-%H%M')}.yml")
      data = {}
      puts "preparing dump for each table..."
      interesting_tables = ActiveRecord::Base.connection.tables.sort - ['sessions']
      interesting_tables.each do |tbl|
        data[tbl] = ActiveRecord::Base.connection.select_all("select * from #{tbl}")
      end
      puts "dumping data from every table..."
      File.open(backup_file,'w') do |file|
        YAML.dump data, file
      end 
    end
  
    desc "Load yml data into database."
    task :load => [:environment, 'db:schema:load'] do 
      connect()
      data = YAML.load(File.read(File.join(RAILS_ROOT, ENV['BACKUP_FILE'])))
      data.each_key do |table|
        if table == 'schema_info'
          ActiveRecord::Base.connection.execute("delete from schema_info")
          ActiveRecord::Base.connection.execute("insert into schema_info (version) values (#{data[table].first['version']})")
        else
          # Create a temporary model to talk to the DB
          eval %Q{
            class TempClass < ActiveRecord::Base
              set_table_name '#{table}'
              reset_column_information
            end
          }
          TempClass.delete_all

          data[table].each do |record|
            r = TempClass.new(record)
            r.id = record['id'] if record.has_key?('id')
            r.save
          end

          if ActiveRecord::Base.connection.respond_to?(:reset_pk_sequence!)
            ActiveRecord::Base.connection.reset_pk_sequence!(table)
          end
        end
      end
    end
  end
end
