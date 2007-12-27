require File.dirname(__FILE__) + '/../test_helper'
require 'zann_controller'

# Re-raise errors caught by the controller.
class ZannController; def rescue_action(e) raise e end; end

class ZannControllerTest < Test::Unit::TestCase
  fixtures :zanns, :users, :photos, :snacks, :videos
  def setup
    @controller = ZannController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:samuel)
    setup_fixture_files
  end

  def test_zann_photo
    photo_amount = Zann.count
    post :new, {:zannee_type => 'photo', :zannee_id => 1}
    assert_equal photo_amount + 1, Zann.count
    assert_template "photos/_zann_counter"
  end
  
  def test_zann_snack
    amount = Zann.count
    post :new, {:zannee_type => 'snack', :zannee_id => 1}
    assert_equal amount + 1, Zann.count
    assert_template "snacks/_zann_counter"
  end

  def test_zann_video
    amount = Zann.count
    post :new, {:zannee_type => 'video', :zannee_id => 1}
    assert_equal amount + 1, Zann.count
    assert_template "videos/_zann_counter"
  end

  def teardown
    teardown_fixture_files
  end
end
