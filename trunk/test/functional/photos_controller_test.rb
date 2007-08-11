require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  fixtures :photos, :users

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @shanghai_1_id = photos(:shanghai_1).id
    @request.session[:user] = users(:samuel)
    setup_fixture_files
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:photos)
  end

  def test_show
    get :show, :id => @shanghai_1_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:photo)
  end

  def test_create
    num_photos = Photo.count

    post :create, :photo => {:name => 'new shanghai city', :description => 'better city, better life', :album_id => 1, :image => upload("#{RAILS_ROOT}/test/fixtures/file_column/test/shanghai_map.jpg")}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_photos + 1, Photo.count
  end

  def test_edit
    get :edit, :id => @shanghai_1_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_update
    post :update, :id => @shanghai_1_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @shanghai_1_id
  end

  def test_destroy
    assert_nothing_raised {
      Photo.find(@shanghai_1_id)
    }

    post :destroy, :id => @shanghai_1_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Photo.find(@shanghai_1_id)
    }
  end
  
  def teardown
    teardown_fixture_files
  end
end
