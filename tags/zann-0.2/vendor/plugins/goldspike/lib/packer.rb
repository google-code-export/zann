
module War
  
  class Packer
	
	  attr_accessor :config
	
	  def initialize(config)
	    @config = config
	  end
	  
    def install(source, dest, mode=0644)
      File.install(source, dest, mode)
    end
	  
	  def copy_tree(files, target, strip_prefix='')
	    files.each do |f|
	      relative = f[strip_prefix.length, f.length]
	      target_file = File.join(target, relative)
	      if File.directory?(f)
	        File.makedirs(target_file)
	      elsif File.file?(f)
	        # puts "  Copying #{f} to #{relative}"
	        File.makedirs(File.dirname(target_file))
	        install(f, target_file)
	      end
	    end    
	  end
	  
	  def compile_tree(dir, config)
	    return unless config.compile_ruby
	    # find the libraries
	    classpath_files = Rake::FileList.new(File.join(config.staging, 'WEB-INF', 'lib', '*.jar'))
	    classpath = classpath_files.to_a.join(config.os_path_separator)
	    # compile the files
	    os_dir = dir.gsub(File::SEPARATOR, config.os_separator)
	    unless system("cd #{os_dir} && java -cp #{classpath} org.jruby.webapp.ASTSerializerMain #{'--replace' unless config.keep_source}")
	      raise "Error: failed to preparse files in #{dir}, returned with error code #{$?}"    
	    end
	  end
	  
	  def jar(target_file, source_dir, compress=true)
	    os_target_file = target_file.gsub(File::SEPARATOR, config.os_separator)
	    os_source_dir = source_dir.gsub(File::SEPARATOR, config.os_separator)
	    flags = '-cf'
	    flags += '0' unless compress
	    unless system("jar #{flags} #{os_target_file} -C #{os_source_dir} .")
	      raise "Error: failed to create archive, error code #{$?}"
	    end
	  end
	  
  end
  
  class JavaLibPacker < Packer
    
    def initialize(config)
      super(config)
    end
    
    def add_java_libraries
      staging = config.staging
      lib = File.join(staging, 'WEB-INF', 'lib')
      File.makedirs(lib)
      for library in config.java_libraries.values
        target = File.join(lib, library.file)
        unless File.exists?(target)
          puts "  Adding Java library #{library}"
          library.install(config, target)
        end
      end
    end
  end
  
  class RubyLibPacker < Packer

    def initialize (config)
      super(config)
    end
    
    def add_ruby_libraries
      # add the gems
      gem_home = File.join(config.staging, 'WEB-INF', 'gems')
      File.makedirs(gem_home)
      File.makedirs(File.join(gem_home, 'gems'))
      File.makedirs(File.join(gem_home, 'specifications'))
      for gem in config.gem_libraries
        copy_gem(gem[0], gem[1], gem_home)
      end
    end
    
    def copy_gem(name, match_version, target_gem_home)
      require 'rubygems'
      matched = Gem.source_index.search(name, match_version)
      raise "The #{name} gem is not installed" if matched.empty?
      gem = matched.last

      #gem_target = File.join(target_gem_home, "#{gem.name}-#{gem.version}.gem")
      gem_target = File.join(target_gem_home, 'gems', "#{gem.name}-#{gem.version}")

      unless File.exists?(gem_target)
        #####################
        ## package up the gem
        #puts "  Adding Ruby gem #{gem.name} version #{gem.version}"
        ## copy the cache file
        #gem_source = File.join(Gem.path, 'cache', "#{gem.name}-#{gem.version}.gem")
        #install(gem_source, target_gem_home, 0644)
        #####################

        # package up the gem
        puts "  Adding Ruby gem #{gem.name} version #{gem.version}"
        # copy the specification
        install(gem.loaded_from, File.join(target_gem_home, 'specifications'), 0644)
        # copy the files
        File.makedirs(gem_target)
        gem_files = Rake::FileList.new(File.join(gem.full_gem_path, '**', '*'))
        copy_tree(gem_files, gem_target, gem.full_gem_path)
        # compile the .rb files to .rb.ast.ser
        compile_tree(File.join(gem_target, 'lib'), config)

      end
      # handle dependencies
      if config.add_gem_dependencies
        for gem_child in gem.dependencies
          #puts "  Gem #{gem.name} requires #{gem_child.name} "
          copy_gem(gem_child.name, gem_child.requirements_list, target_gem_home)
        end
      end
    end
    
  end
  
  class WebappPacker < Packer

    def initialize(config)
      super(config)
    end
    
    def create_war
      jar(config.war_file, config.staging)
    end
    
    def add_webapp
      staging = config.staging
      puts '  Adding web application'
      File.makedirs(staging)
      webapp_files = Rake::FileList.new(File.join('.', '**', '*'))
      webapp_files.exclude(staging)
      webapp_files.exclude('*.war')
      webapp_files.exclude(config.local_java_lib)
      webapp_files.exclude(File.join('public', '.ht*'))
      webapp_files.exclude(File.join('public', 'dispatch*'))
      webapp_files.exclude(File.join('log', '*.log'))
      webapp_files.exclude(File.join('tmp', 'cache', '*'))
      webapp_files.exclude(File.join('tmp', 'sessions', '*'))
      webapp_files.exclude(File.join('tmp', 'sockets', '*'))
      webapp_files.exclude(File.join('tmp', 'jetty'))
      config.excludes.each do |exclude|
        webapp_files.exclude(exclude)
      end
      copy_tree(webapp_files, staging)
      compile_tree(staging, config)
    end
    
  end  
end 
