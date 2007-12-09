#
# Configuration for building a war file
# By Robert Egglestone
#    Fausto Lelli
#
module War
  class Configuration

    # the name of the project
    attr_accessor :name
    # the path and name of the war_file
    attr_accessor :war_file
    # path to the staging directory
    attr_accessor :staging
    # a list of patterns of excluded files
    attr_accessor :excludes
    # project java libraries are stored here
    attr_accessor :local_java_lib
    # servlet to use for running Rails
    attr_accessor :servlet
    # enable jndi support?
    attr_accessor :datasource_jndi
    attr_accessor :datasource_jndi_name

    # external locations
    attr_accessor :jruby_home
    attr_accessor :maven_local_repository
    attr_accessor :maven_remote_repository

    # compile ruby files? currently only preparses files, but has problems with paths
    attr_accessor :compile_ruby
    # keep source if compiling ruby files?
    attr_accessor :keep_source
    # if you set this to false gems will fail to load if their dependencies aren't available
    attr_accessor :add_gem_dependencies
    # standalone?
    attr_accessor :standalone
    # rails environment?
    attr_accessor :rails_env

    # java libraries to include in the package
    attr_accessor :java_libraries
    # gem libraries to include in the package
    attr_accessor :gem_libraries
    # jetty libraries, used for running the war
    attr_accessor :jetty_libraries

    # the real separator for the operating system
    attr_accessor :os_separator
    attr_accessor :os_path_separator

    def initialize

      # default internal locations
      @rails_basedir = File.dirname(File.dirname(File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__))))))
      @staging = File.join('tmp', 'war')
      @excludes = []
      @local_java_lib = File.join('lib', 'java')

      # default build properties
      @compile_ruby = false
      @keep_source =  false
      @add_gem_dependencies = true
      @servlet = 'org.jruby.webapp.RailsServlet'
      @rails_env = 'production'
      @datasource_jndi = false

      home = ENV['HOME'] || ENV['USERPROFILE']
      @jruby_home = ENV['JRUBY_HOME']
      @maven_local_repository = ENV['MAVEN2_REPO'] # should be in settings.xml, but I need an override
      @maven_local_repository ||= File.join(home, '.m2', 'repository') if home
      @maven_remote_repository = 'http://www.ibiblio.org/maven2'

      # configured war name, defaults to the same as the ruby webapp
      @name = File.basename(@rails_basedir)
      @war_file = "#{@name}.war"

      @java_libraries = {}
      # default java libraries
      add_java_library(maven_library('org.jruby', 'jruby-complete', '1.0'))
      add_java_library(maven_library('org.jruby.extras', 'rails-integration', '1.1.1'))
      add_java_library(maven_library('javax.activation', 'activation', '1.1'))
      add_java_library(maven_library('commons-pool', 'commons-pool', '1.3'))
      add_java_library(maven_library('bouncycastle', 'bcprov-jdk14', '124'))

      # default gems
      @gem_libraries = {}
      if !File.exists?('vendor/rails')
        add_gem('rails', rails_version)
      end
      add_gem('ActiveRecord-JDBC')

      # default jetty libraries
      @jetty_libraries = {}
      add_jetty_library(maven_library('org.mortbay.jetty', 'start', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-util', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'servlet-api-2.5', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-plus', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-naming', '6.1.1'))
      
      # separators
      if RUBY_PLATFORM =~ /(mswin)|(cygwin)/i # watch out for darwin
        @os_separator = '\\'
        @os_path_separator = ';'
      elsif RUBY_PLATFORM =~ /java/i
        @os_separator = java.io.File.separator
        @os_path_separator = java.io.File.pathSeparator
      else
        @os_separator = File::SEPARATOR
        @os_path_separator = File::PATH_SEPARATOR
      end

      # load user configuration
      load_user_configuration

    end # initialize
    
    def exclude_files(pattern)
      @excludes << pattern
    end

    def datasource_jndi_name
      @datasource_jndi_name || "jdbc/#{name}"
    end

    # Get the rails version from environment.rb, or default to the latest version
    # This can be overriden by using add_gem 'rails', ...
    def rails_version
      environment_without_comments = IO.readlines(File.join('config', 'environment.rb')).reject { |l| l =~ /^#/ }.join
      environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
      version = $1
      version ? "= #{version}" : nil
    end

    #def is_conf(name)
    #   return true if @config_db and @config_db[name]
    #end

    def load_user_configuration
      user_config = File.join(@rails_basedir, 'config', 'war.rb')
      if File.exists?(user_config)
        begin
          puts "Reading user configuration"
          @config_db = War::Configuration::DSL.evaluate(user_config, self).result
        rescue => e
          puts e.backtrace.join("\n")
          puts "Error reading user configuration (#{e.message}), using defaults"
        end
      end
    end

    def java_library(name, version, locations)
      # check local sources first, then the list
      check_locations = local_locations(name, version)
      locations = [ locations ] if locations.is_a?(String)
      check_locations += locations
      JavaLibrary.new(name, version, check_locations)
    end

    def maven_library(group, name, version)
      locations = maven_locations(group, name, version)
      java_library(name, version, locations)
    end

    def add_java_library(lib)
      @java_libraries[lib.artifact] = lib
    end

    def add_jetty_library(lib)
      @jetty_libraries[lib.artifact] = lib
    end

    def add_gem(name, match_version=nil)
      @gem_libraries[name] = match_version
    end

    def local_locations(artifact, version, type='jar')
      paths = []
      if local_java_lib
        paths << File.join(local_java_lib, "#{artifact}-#{version}.#{type}")
        paths << File.join(local_java_lib, "#{artifact}.#{type}")
      end
      if jruby_home
        paths << File.join(jruby_home, 'lib', "#{artifact}-#{version}.#{type}")
        paths << File.join(jruby_home, 'lib', "#{artifact}.#{type}")
      end
      return paths
    end

    def maven_locations(group, artifact, version, type='jar')
      paths = []
      if maven_local_repository
        paths << File.join(maven_local_repository, group.gsub('.', File::SEPARATOR), artifact, version, "#{artifact}-#{version}.#{type}")
      end
      if maven_remote_repository
        paths << "#{maven_remote_repository}/#{group.gsub('.', '/')}/#{artifact}/#{version}/#{artifact}-#{version}.#{type}"
      end
      return paths
    end

    # This class is responsable for loading the war.rb dsl and parsing it to
    # evaluated War::Configuration
    # <note>will need to readjust this package impl </note>
    class DSL

      # saves internally the parsed result
      attr_accessor :result

      def initialize (configuration)
        @result = configuration
      end

      # method hook for name property
      def war_file(*val)
        puts "Warning: property 'name' takes only one argument" if val.size > 1
        @result.war_file = val[0]
      end
      
      def exclude_files(*val)
        puts "Warning: property 'exclude_files' takes only one argument" if val.size > 1
        @result.exclude_files(val[0])
      end

      def servlet(*val)
        puts "Warning: property 'servlet' takes only one argument" if val.size > 1
        @result.servlet = val[0]
      end

      def compile_ruby(*val)
        puts "Warning: property 'compile_ruby' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          puts "Warning: property 'compile_ruby' must be either true or false"
          return
        end
        @result.compile_ruby = val[0]
      end

      def add_gem_dependencies(*val)
        puts "Warning: property 'add_gem_dependencies' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          puts "Warning: property 'add_gem_dependencies' must be either true or false"
          return
        end
        @result.add_gem_dependencies = val[0]
      end

      def keep_source(*val)
        puts "Warning: property 'keep_source' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          puts "Warning: property 'keep_source' must be either true or false"
          return
        end
        @result.keep_source = val[0]
      end
      
      def add_gem(*val)
          puts "Warning: add_gem takes at most two arguments" if val.size > 2
          @result.add_gem(val[0], val[1])
      end

      def datasource_jndi(*val)
        puts "Warning: property 'datasource_jndi' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          puts "Warning: property 'datasource_jndi' must be either true or false"
          return
        end
        @result.datasource_jndi = val[0]
      end

      def datasource_jndi_name(*val)
          puts "Warning: datasource_jndi_name takes at most one argument" if val.size > 1
          @result.datasource_jndi_name = val[0]
      end

      # method hook for library property
      def include_library(name, properties)
        if properties == nil or properties[:version] == nil or properties[:locations] == nil
        	puts "Warning: in library #{name}, 'version' and 'locations' specifications are mandatory"
        	return
        end
        begin
          @result.add_java_library(@result.java_library(name, properties[:version], properties[:locations]))
        rescue
          puts "Warning: couldn't load library #{name}, check library definition in the config file"
        end
      end

      # method hook for maven library property
      def maven_library(group, name, version)
        begin
          @result.add_java_library(@result.maven_library(group, name, version))
        rescue
          puts "Warning: couldn't load maven library #{name}, check library definition in the config file"
        end
      end

      # method hook for default behaviour when an unknown property
      # is met in the dsl. By now, just ignore it and print a warning
      # message
      def method_missing(name, *args)
        puts "Warning: property '#{name}' in config file not defined"
      end

      # main parsing method. pass the file name for the dsl and the configuration
      # reference to evaluate against.
      def self.evaluate(filename, configuration)
        raise "file #{filename} not found " unless File.exists?(filename)
        dsl = new(configuration)
        dsl.instance_eval(File.read(filename) , filename)
        dsl
      end

      # utility
      def is_either_true_or_false?(obj)
        obj.class == TrueClass or obj.class == FalseClass
      end
    end #class DSL

  end #class
end #module
