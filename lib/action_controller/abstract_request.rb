ActionController::AbstractRequest.class_eval do
  def headers
    @env
  end
end