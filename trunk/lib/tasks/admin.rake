namespace :zann do
  namespace :admin do
    desc "Give administration permission to a user"
    task :grant => :environment do
      CONFIG['cas_enabled'] = true
      if modify(true)
        puts "Succeeded to grant administration permission."
      else
        puts "Failed to grant administration permission."
      end
    end
    
    desc "Take away administration permission from a user"
    task :ungrant => :environment do
      if modify(false)
        puts "Succeeded to remove administration permission."
      else
        puts "Failed to remove administration permission."
      end
    end
    
    def modify(grant)
      user = find_user
      if(grant)
        user.has_role 'admin'
      else
        user.has_no_role 'admin'
      end
      user.save!
    end
    
    def find_user
      user = User.find_by_login(ENV['USER'])
      if user.nil?
        raise "User " + ENV['USER'] + " cannot be found."
      end
      user
    end
  end
end