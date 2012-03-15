require File.dirname(__FILE__) + '/../test_helper'
require 'snacks_controller'

# Re-raise errors caught by the controller.
class SnacksController; def rescue_action(e) raise e end; end

class SnacksControllerTest < ActionController::TestCase
  def setup
	super
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

end
