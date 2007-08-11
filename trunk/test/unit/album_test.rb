require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < Test::Unit::TestCase
  fixtures :albums

  # Replace this with your real tests.
  def test_basic
    assert_equal 2, Album.count
  end
  
end
