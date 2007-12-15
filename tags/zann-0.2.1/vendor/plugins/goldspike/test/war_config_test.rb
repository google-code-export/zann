require 'test/unit'
require 'war_config'

class WarConfigTest < Test::Unit::TestCase
  
  def test_no_config_file
    assert_raises RuntimeError do
      War::Configuration::DSL.evaluate(File.join("abase","config","war.rb"), nil)
    end
  end
  
  class WarConfigurationMock 
    # the path and name of the war_file
    attr_accessor :war_file
    # path to the staging directory
    attr_accessor :staging
    # project java libraries are stored here
    attr_accessor :local_java_lib
    
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
      @java_libraries = {}
    end
    
    def java_library(name, version, locations)
      # check local sources first, then the list
      #JavaLibrary.new(name, version, check_locations)
      {:name => name, :version => version, :locations => locations}
    end
    
    def add_java_library(lib)
      @java_libraries[lib[:name]] ||= lib
    end
    
  end
  
  def test_war_name_read
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_equal 'helloworld', config.war_file 
  end
  
  def test_library_read
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_equal 1, config.java_libraries.size
  end  
  
  def test_library_read_with_properties
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_not_nil config.java_libraries['bsf']
    assert_equal 'bsf', config.java_libraries['bsf'][:name]
    assert_equal '2.2.1', config.java_libraries['bsf'][:version]
    assert_equal 'http://www.google.it', config.java_libraries['bsf'][:locations]
  end
  
  def test_compile_ruby
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_not_nil config.compile_ruby
    assert config.compile_ruby
  end
  
  def test_add_gem_dependencies
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_not_nil config.add_gem_dependencies
    assert !config.add_gem_dependencies
  end
  
  def test_keep_source
    config = War::Configuration::DSL.evaluate("test/war_config_test_config.rb",WarConfigurationMock.new).result
    assert_not_nil config.keep_source
    assert !config.keep_source
  end
end
