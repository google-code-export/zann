# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
#require 'has_many_polymorphs'
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  config.active_record.observers = :user_observer

  config.action_controller.session = {
    :session_key => '_zann_session',
    :secret      => '70376e4d0af5bfe7045354d7a7890ac867bbbcce60b2cbfd057966c86303561ac047aff310648d2f82c367e4e65efc51a6b9cbf298d08d6ae5a33862d878a342'
  }
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
require 'error_style'

AUTHORIZATION_MIXIN = 'object roles'
DEFAULT_REDIRECTION_HASH = { :controller => 'account', :action => 'login' }
# add tag suppport to ActiveRecord::Base via RAILS_ROOT/lib/tag_extenstions.rb
require 'tag_extensions'

zann_yml = File.read File.join(RAILS_ROOT, 'config', 'zann.yml') rescue nil
CONFIG = YAML.load(zann_yml)
FFMPEG_PATH = CONFIG['ffmpeg_path']
MP3_CODEC = CONFIG['mp3_codec']

if CONFIG['cas_enabled']
  require 'casclient'
  require 'casclient/frameworks/rails/filter'
  require 'action_controller/abstract_request'
  CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => CONFIG['cas_base_url']
  )  
end

#require 'will_paginate'
