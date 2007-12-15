#
# Building a war file
#
# By Robert Egglestone
#    Fausto Lelli (*minor* patches for windows platform, plugin dist.)
#

require 'fileutils'
require 'java_library'
require 'war_config'
require 'packer'

module War
  class Creator

    attr_accessor :config

    def initialize
      @config = Configuration.new
      @java_lib_packer = JavaLibPacker.new(@config)
      @ruby_lib_packer = RubyLibPacker.new(@config)
      @webapp_packer = WebappPacker.new(@config)
    end

    def standalone=(value)
      @config.standalone = value
    end

    def create_shared_war
      @config.standalone = false
      create_war_file
    end

    def create_standalone_war
      @config.standalone = true
      create_war_file
    end

    def clean_war
      FileUtils.remove_file(@config.war_file) if File.exists?(@config.war_file)
      FileUtils.remove_dir(@config.staging) if File.exists?(@config.staging)
    end

    def create_war_file
      assemble
      create_war
    end

    def assemble
      puts 'Assembling web application'
      add_java_libraries
      add_webapp
      if config.standalone
        add_ruby_libraries
      end
      add_webxml
    end

    private

    def create_war
      puts 'Creating web archive'
      @webapp_packer.create_war
    end

    def add_webapp
      @webapp_packer.add_webapp
    end

    def add_java_libraries
      @java_lib_packer.add_java_libraries
    end

    def add_ruby_libraries
      @ruby_lib_packer.add_ruby_libraries
    end

    def create_webxml
      require 'erb'
      template = <<END_OF_WEB_INF
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://java.sun.com/xml/ns/j2ee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
  version="2.4">

<context-param>
  <param-name>jruby.standalone</param-name>
  <param-value><%= config.standalone %></param-value>
</context-param>

<% if !config.standalone %>
<!-- jruby.home can be set either here, or as the system property jruby.home -->
<context-param>
  <param-name>jruby.home</param-name>
  <param-value><%= config.jruby_home || '/usr/local/jruby' %></param-value>
</context-param>
<% end %>

<context-param>
  <param-name>rails.env</param-name>
  <param-value><%= config.rails_env %></param-value>
</context-param>

<context-param>
  <description>The files servlet should forward to the rails servlet if no file could be found</description>
  <param-name>files.default</param-name>
  <param-value>rails</param-value>
</context-param>

<servlet>
  <servlet-name>rails</servlet-name>
  <servlet-class><%= config.servlet %></servlet-class>
</servlet>
<servlet>
  <servlet-name>files</servlet-name>
  <servlet-class>org.jruby.webapp.FileServlet</servlet-class>
</servlet>

<!-- Allow all requests to go to the files servlet first -->
<servlet-mapping>
  <servlet-name>files</servlet-name>
  <url-pattern>/</url-pattern>
</servlet-mapping>

<% if config.datasource_jndi %>
<resource-ref>
  <res-ref-name><%= config.datasource_jndi_name %></res-ref-name>
  <res-type>javax.sql.DataSource</res-type>
  <res-auth>Container</res-auth>
</resource-ref>
<% end %>

</web-app>
END_OF_WEB_INF

      erb = ERB.new(template)
      erb.result(binding)
    end

    def add_webxml
      unless File.exists?(File.join('WEB-INF', 'web.xml'))
        config_webxml = File.join('config', 'web.xml')
        webxml = File.read(config_webxml) if File.exists?(config_webxml)
        webxml ||= create_webxml
        File.makedirs(File.join(config.staging, 'WEB-INF'))
        File.open(File.join(config.staging, 'WEB-INF', 'web.xml'), 'w') { |out| out << webxml }
      end
    end

  end #class
end #module
