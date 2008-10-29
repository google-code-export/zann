require File.dirname(__FILE__) + '/../test_helper'
require 'snacks_controller'

# Re-raise errors caught by the controller.
class SnacksController; def rescue_action(e) raise e end; end

class SnacksControllerTest < Test::Unit::TestCase
  def setup
    @controller = SnacksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

end
