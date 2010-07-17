# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_zann_session_id'
  include AuthenticatedSystem
  include CASAuthentication
  before_filter :login_from_cookie
  
  if CONFIG['cas_enabled']
    before_filter CASClient::Frameworks::Rails::Filter
    before_filter :cas_login
  end
  
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 12, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
end
