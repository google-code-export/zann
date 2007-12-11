require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < Test::Unit::TestCase
  fixtures :photos, :zanns, :comments, :users, :roles, :roles_users
  
  def setup
    setup_fixture_files
  end
  
  def test_zanns_count
    photo_shanghai = photos(:shanghai_1)
    assert_equal 2, photo_shanghai.zanns_count
    assert_equal 0, photos(:cat_9).zanns_count
  end
  
  def test_view_once
    photo_shanghai = photos(:shanghai_1)
    assert_equal 20, photo_shanghai.view_count
    photo_shanghai.view_once
    assert_equal 21, photo_shanghai.view_count
  end
  
  def test_destroy
    commented_photo = photos(:shanghai_2)
    assert_equal 2, Comment.find(:all).length
    commented_photo.destroy
    assert_equal 0, Comment.find(:all).length
    zanned_photo = photos(:shanghai_1)
    assert_equal 2, Zann.find(:all).length
    zanned_photo.destroy
    assert_equal 0, Zann.find(:all).length
  end
  
  def test_photos_count_in_one_day
    photos_count = Photo.photos_count_until_day(Time.local(2007, 8, 10))
    assert_equal 5, photos_count
    photos_count = Photo.photos_count_until_day(Time.local(2007, 8, 11))
    assert_equal 12, photos_count    
    photos_count = Photo.photos_count_until_day(Time.local(2007, 8, 12))
    assert_equal 17, photos_count
  end
  
  def teardown
    teardown_fixture_files
  end
end