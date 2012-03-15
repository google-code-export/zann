require File.dirname(__FILE__) + '/../test_helper'
require 'albums_controller'

# Re-raise errors caught by the controller.
class AlbumsController; def rescue_action(e) raise e end; end

class AlbumsControllerTest < ActionController::TestCase
  fixtures :albums, :users, :roles, :roles_users

  def setup
	super

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

  def test_add_album_admin
    post :grant, :album_id => @shanghai_id, :admin_email => 'chen_charlie@emc.com'
    assert_response :redirect
    assert_redirected_to :action => 'admin'
    shanghai_album = Album.find(@shanghai_id)
    assert_equal 3, shanghai_album.admins.length
  end

  def test_add_existing_album_admin
    post :grant, :album_id => @shanghai_id, :admin_email => 'ni_yue@emc.com'
    assert_response :redirect
    assert_redirected_to :action => 'admin'
    shanghai_album = Album.find(@shanghai_id)
    assert_equal 2, shanghai_album.admins.length
  end

  def test_add_unexisting_user_as_album_admin
    post :grant, :album_id => @shanghai_id, :admin_email => 'no_such_user@emc.com'
    assert_response :redirect
    assert_redirected_to :action => 'admin'
    assert_not_nil flash[:warning]
  end

  def test_remove_existing_album_admin
    post :ungrant, :album_id => @shanghai_id, :admin_email => 'ni_yue@emc.com'
    assert_response :redirect
    assert_redirected_to :action => 'admin'
    shanghai_album = Album.find(@shanghai_id)
    assert_equal 1, shanghai_album.admins.length
  end
end
