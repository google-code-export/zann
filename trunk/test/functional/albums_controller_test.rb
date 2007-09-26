require File.dirname(__FILE__) + '/../test_helper'
require 'albums_controller'

# Re-raise errors caught by the controller.
class AlbumsController; def rescue_action(e) raise e end; end

class AlbumsControllerTest < Test::Unit::TestCase
  fixtures :albums, :users, :roles, :roles_users

  def setup
    @controller = AlbumsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @shanghai_id = albums(:shanghai).id
    @request.session[:user] = users(:joetucci)
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

    assert_not_nil assigns(:albums)
  end

  def test_show
    get :show, :id => @shanghai_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:album)
    assert assigns(:album).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:album)
  end

  def test_create
    num_albums = Album.count

    post :create, :album => {:name => 'emc album', :description => 'emc family', :creator_id => 1, :created_at => '2007-08-11'}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_albums + 1, Album.count
  end

  def test_edit
    get :edit, :id => @shanghai_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:album)
    assert assigns(:album).valid?
  end

  def test_update
    post :update, :id => @shanghai_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @shanghai_id
  end

  def test_destroy
    assert_nothing_raised {
      Album.find(@shanghai_id)
    }

    post :destroy, :id => @shanghai_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Album.find(@shanghai_id)
    }
  end
end
