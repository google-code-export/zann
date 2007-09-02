require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < Test::Unit::TestCase
  fixtures :albums, :photos

  # Replace this with your real tests.
  def test_basic
    assert_equal 2, Album.count
  end
  
  def winner_photo
    album_shanghai = albums(:shanghai)
    album_winner_photo = album_shangha.winner_photo
    assert_not_nil album_winner_photo
  end
end
