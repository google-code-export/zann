require 'war_config'
require 'fileutils'

module War
  class Runner 
    
    attr_accessor :config
    attr_accessor :jetty_main
    attr_accessor :jetty_port
    attr_accessor :jetty_tmp
    attr_accessor :jetty_config
    attr_accessor :classpath
    attr_accessor :java_opts
    
    def initialize
      @config = Configuration.new
      @jetty_main = 'org.mortbay.start.Main'
      @jetty_port = 8080
      @jetty_tmp = File.join('tmp', 'jetty')
      @jetty_config = File.join(jetty_tmp, 'jetty.xml')
      @java_opts = ''
    end
    
    def run_standalone
      @config.standalone = true
      run
    end
    
    def run
      add_jetty_libraries
      add_jetty_config
      classpath_string = classpath.join(config.os_path_separator)
      java_opts = self.java_opts
      java_opts << ' -Xmx128m' unless java_opts =~ /-Xmx/
      system("java #{java_opts} -cp \"#{classpath_string}\" #{jetty_main} #{jetty_config}")
    end
    
    def java_opts
      ENV['JAVA_OPTS'] || @java_opts
    end
    
    def add_jetty_libraries
      # Get the Jetty libraries
      @classpath = []
      File.makedirs(jetty_tmp)
      for lib in config.jetty_libraries.values
        target = File.join(jetty_tmp, lib.file)
        unless File.exists?(target)
          puts "Downloading #{lib.file}..."
          lib.install(config, target)
        end
        @classpath << target
      end
    end
    
    def add_jetty_config
      # Create the configuration
      jetty_user_config = File.join('config', 'jetty.xml')
      jetty_config_data = File.read(jetty_user_config) if File.exists?(jetty_user_config)
      jetty_config_data ||= create_jetty_config
      File.open(jetty_config, 'w') { |out| out << jetty_config_data }
    end
    
    def create_jetty_config
      require 'erb'
      template = <<END_OF_JETTY_XML
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-//Mort Bay Consulting//DTD Configure//EN" "http://jetty.mortbay.org/configure.dtd">
<Configure id="Server" class="org.mortbay.jetty.Server">

    <Set name="ThreadPool">
      <New class="org.mortbay.thread.BoundedThreadPool">
        <Set name="minThreads">10</Set>
        <Set name="lowThreads">50</Set>
        <Set name="maxThreads">250</Set>
      </New>
    </Set>

    <Call name="addConnector">
      <Arg>
          <New class="org.mortbay.jetty.nio.SelectChannelConnector">
            <Set name="port"><SystemProperty name="jetty.port" default="8080"/></Set>
            <Set name="maxIdleTime">30000</Set>
            <Set name="Acceptors">2</Set>
            <Set name="confidentialPort">8443</Set>
          </New>
      </Arg>
    </Call>
    
    <Set name="handlers">
      <Array type="org.mortbay.jetty.Handler">
        <Item>
          <New class="org.mortbay.jetty.webapp.WebAppContext">
            <Arg><%= config.staging %></Arg>
            <Arg>/<%= config.name %></Arg>
            <Set name="ConfigurationClasses">
              <Array id="plusConfig" type="java.lang.String">
                <Item>org.mortbay.jetty.webapp.WebInfConfiguration</Item>
                <Item>org.mortbay.jetty.plus.webapp.EnvConfiguration</Item>
                <Item>org.mortbay.jetty.plus.webapp.Configuration</Item>
                <Item>org.mortbay.jetty.webapp.JettyWebXmlConfiguration</Item>
                <Item>org.mortbay.jetty.webapp.TagLibConfiguration</Item>
              </Array>
            </Set>
          </New>
        </Item>
        <Item>
          <New id="DefaultHandler" class="org.mortbay.jetty.handler.DefaultHandler"/>
        </Item>
        <Item>
          <New id="RequestLog" class="org.mortbay.jetty.handler.RequestLogHandler"/>
        </Item>
      </Array>
    </Set>

    <Ref id="RequestLog">
      <Set name="requestLog">
        <New id="RequestLogImpl" class="org.mortbay.jetty.NCSARequestLog">
          <Arg>log/jetty.request.log</Arg>
          <Set name="append">true</Set>
          <Set name="extended">false</Set>
          <Set name="LogTimeZone">GMT</Set>
        </New>
      </Set>
    </Ref>

    <Set name="stopAtShutdown">true</Set>
    <Set name="sendServerVersion">true</Set>

</Configure>
END_OF_JETTY_XML
      
      erb = ERB.new(template)
      erb.result(binding)
    end
    
  end #class
end #module