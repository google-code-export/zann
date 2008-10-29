require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < Test::Unit::TestCase
  fixtures :albums, :photos, :users, :roles, :roles_users

  # Replace this with your real tests.
  def test_basic
    assert_equal 2, Album.count
  end
  
  def test_winner_photo
    album_shanghai = albums(:shanghai)
    album_winner_photo = album_shanghai.winner_photo
    assert_not_nil album_winner_photo
    assert_equal 1, album_winner_photo.id 
  end

  def test_find_tags_of_photos_in_one_album
    album_shanghai = albums(:shanghai)
    tags = album_shanghai.find_tags_in_album
    assert 2, tags.length
  end

  def test_find_album_admins
    album_shanghai = albums(:shanghai)
    shanghai_album_admins = album_shanghai.admins
    assert_equal 2, shanghai_album_admins.length
  end

  def test_reset_photo_zanns_count_in_album
    assert_equal 2, Photo.find(1).zanns_count
    album_shanghai = albums(:shanghai)
    album_shanghai.reset_zanns_count
    assert_equal 0, Photo.find(1).zanns_count
  end
end
