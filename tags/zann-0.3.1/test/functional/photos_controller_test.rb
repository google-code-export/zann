require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  fixtures :photos, :users, :roles, :roles_users, :albums

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @shanghai_1_id = photos(:shanghai_1).id
    @request.session[:user] = users(:samuel)
    setup_fixture_files
  end

  def test_index
    @request.session[:user] = nil
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
    view_count = photos(:shanghai_2).view_count
    shanghai_2_id = photos(:shanghai_2).id
    get :show, :id => shanghai_2_id
    #photo  creator is yolanda, viewed by samuel, so view count increase
    assert_equal view_count + 1, Photo.find(shanghai_2_id).view_count

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
    
    view_count = photos(:shanghai_1).view_count
    get :show, :id => @shanghai_1_id
    #photo  creator is samuel, viewed by samuel, so view count does not increase
    assert_equal view_count, Photo.find(@shanghai_1_id).view_count
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

  def test_create_with_tag
    num_photos = Photo.count

    post :create,
         :photo => {:name => 'new shanghai city', 
                    :description => 'better city, better life',
                    :album_id => 1,
                    :image => upload("#{RAILS_ROOT}/test/fixtures/file_column/test/shanghai_map.jpg")
                    },
         :tag_list => 'shanghai map'

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_photos + 1, Photo.count
		tagged_photo = Photo.find_by_name('new shanghai city')
    assert tagged_photo.tag_list.include?('shanghai')
    assert tagged_photo.tag_list.include?('map')
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
