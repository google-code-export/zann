require File.dirname(__FILE__) + '/../test_helper'
require 'zann_controller'

# Re-raise errors caught by the controller.
class ZannController; def rescue_action(e) raise e end; end

class ZannControllerTest < Test::Unit::TestCase
  fixtures :zanns, :users
  def setup
    @controller = ZannController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:samuel)
  end

  def test_create
    amount = Zann.count
    post :new, {:zannee_type => 'photo', :zannee_id => 1}
    assert_equal amount + 1, Zann.count
    assert_not_nil flash[:notice]
  end
end
