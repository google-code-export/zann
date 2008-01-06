require File.dirname(__FILE__) + '/../test_helper'
require 'videos_controller'

# Re-raise errors caught by the controller.
class VideosController; def rescue_action(e) raise e end; end

class VideosControllerTest < Test::Unit::TestCase
  fixtures :users, :videos, :roles, :roles_users
  def setup
    @controller = VideosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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

    assert_not_nil assigns(:videos)
  end
  
  def test_new
    @request.session[:user] = users(:samuel)
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:video)
  end

  def test_show
    show_video_id = 1
    get :show, :id => show_video_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:video)
    assert assigns(:video).valid?
  end

  def test_edit
    @request.session[:user] = users(:samuel)
    edit_video_id = 1
    get :edit, :id => edit_video_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:video)
    assert assigns(:video).valid?
  end

  def test_update
    @request.session[:user] = users(:samuel)
    update_video_id = 1
    post :update, :id => update_video_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => update_video_id
  end

  def test_create_with_tag
    @request.session[:user] = users(:samuel)
    num_videos = Video.count

    post :create,
         :video => {:name => 'show desktop', 
                    :description => 'my mac desktop',
                    :movie=> upload("#{RAILS_ROOT}/test/unit/data/show_desktop.avi")
                    },
         :tag_list => 'mac desktop'

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_videos + 1, Video.count
		tagged_video = Video.find_by_name('show desktop')
    assert tagged_video.tag_list.include?('mac')
    assert tagged_video.tag_list.include?('desktop')
  end

  def test_destroy
    @request.session[:user] = users(:samuel)
    destroy_video_id = 1
    assert_nothing_raised {
      Video.find(destroy_video_id)
    }

    post :destroy, :id => destroy_video_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Video.find(destroy_video_id)
    }
  end

  def test_tag
    get :tag, :id => 'macbook'
    assert_response :success
    assert_template 'videos/tag'
  end

  def test_view_video
    view_video_id = 1
    viewed_video = Video.find(view_video_id)
    view_count = viewed_video.view_count
    post :view, :id => view_video_id
    viewed_video.reload
    assert_equal view_count + 1, viewed_video.view_count
  end

  def teardown
    teardown_fixture_files
  end
end
