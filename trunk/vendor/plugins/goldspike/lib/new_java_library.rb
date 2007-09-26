##
# A library which can hopefully be obtained through one of the following mechanisms:
# + A local artifact: lib/java/jruby-0.9.1.jar
# + An artifact in a local maven repo: ~/.m2/repository/org/jruby/jruby/0.9.1/jruby-0.9.1/jar
# + An artifact in a remote maven repo: http://www.ibiblio.com/maven2/org/jruby/jruby/0.9.1/jruby-0.9.1/jar
#
# By Robert Egglestone
#    Fausto Lelli
#

module War
  
  class JavaLibrary
    
    attr_accessor :config, :identifier, :locations, :versions
    
    
    def initialize(config, identifier, args = nil)
      @config = config
      @identifier = identifier
      @versions =  args[:versions] if args and args[:versions].is_a?(Array)
      @versions = [args[:versions]]if args and args[:versions].is_a?(String)
      @versions ||= []
      @locations = args[:locations] if args and args[:locations].is_a?(Array)
      @locations = [args[:locations]] if args and args[:locations].is_a?(String)
      @locations ||= []
      @searcheable_locations = []    
    end
    
    #    def add_location_and_version(locations = nil, versions = nil)
    #      if versions and versions.is_a?(String)
    #        @versions = [ versions ]
    #      elsif versions and versions.is_a?(Array)
    #        @versions = versions 
    #      end 
    #    end
    
    def searcheable_locations 
      define_searcheable_locations unless @already_defined
      @already_defined = true 
      @searcheable_locations
    end
    
    def define_searcheable_locations 
      if locations and locations.is_a?(String)
        @searcheable_locations = [ locations ]
      elsif locations and locations.is_a?(Array)
        @searcheable_locations = locations 
      end     
      versioned_local_locations    
      unversioned_local_locations
    end
    
    def versioned_local_locations ( type='jar')
      for version in versions   
        if config.local_java_lib
          @searcheable_locations << File.join(config.local_java_lib, "#{identifier}-#{version}.#{type}")
        end
        if config.jruby_home
          @searcheable_locations << File.join(config.jruby_home, 'lib' , "#{identifier}-#{version}.#{type}")
        end
      end
    end
    
    #make sense to search for unexplicitly defined lib in remote ? maybe not
    def versioned_remote_locations ( type='jar')
      @searcheable_locations = []
    end
    
    def unversioned_local_locations ( type='jar')
      if config.local_java_lib
        @searcheable_locations << File.join(config.local_java_lib, "#{identifier}.#{type}")
      end
      if config.jruby_home
        @searcheable_locations <<  File.join(config.jruby_home, 'lib' , "#{identifier}.#{type}")
      end 
    end
    
    def install(config, target_file)
      successful = false
      for location in searcheable_locations
        install_local(config,location,target_file)
        if location[0,5] == 'http:' || location[0,6] == 'https:'
          install_remote(install_remote)
        end
        break if successful
      end
      
      unless successful
        # all attempts have failed, inform the user
        raise <<-ERROR
        The library #{self} could not be installed from in any of the following locations:
          + #{locations.join("
          + ")}
      ERROR
      end
    end
    
    private
    
    def location_exists? (location)
      if location[0,5] == 'http:' || location[0,6] == 'https:'
        response = read_url(location)
        return false unless response
      else
        File.exists?(location)
      end
    end
    
    def install_local(config, file, target_file)
      return false unless File.exists?(file)
      File.install(file, target_file, 0644)
      return true
    end
    
    def install_remote(config, location, target_file)
      response = read_url(location)
      return false unless response
      File.open(target_file, 'wb') { |out| out << response.body }
      return true
    end
    
    # properly download the required files, taking account of redirects
    # this code is almost straight from the Net::HTTP docs
    def read_url(uri_str, limit=10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      require 'net/http'
      require 'uri'
      # setup the proxy if available
      http = Net::HTTP
      if ENV['http_proxy']
        proxy = URI.parse(ENV['http_proxy'])
        http = Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password)
      end
      # download the file
      response = http.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection then read_url(response['location'], limit - 1)
      else false
      end
    end
    
  end #class
  
  class MavenLibrary < JavaLibrary
    
    attr_accessor :group
    
    def initialize(config, identifier, group, versions, args = nil)
      @search_locations = []
      @group = group
      args ||= {}
      args[:versions] = versions
      super(config,identifier,args)
    end
    
    def searcheable_locations
      unless @defined_already 
        maven_locations  
        for alocation in super
          @search_locations << alocation
        end
      end
      @defined_already = true
      @search_locations
    end
    
    def maven_locations ( type='jar')
      for version in versions   
        if config.local_maven_lib
          @search_locations << File.join(File.join(File.join(File.join(config.local_maven_lib, group),identifier),version),"#{identifier}-#{version}.#{type}")
        end
        if config.remote_maven_home
          @search_locations << "#{config.remote_maven_home}/#{group}/#{identifier}/#{version}/#{identifier}-#{version}.#{type}"
        end
      end
    end      
    
  end
  
end #module