require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < Test::Unit::TestCase
  fixtures :photos, :zanns
  
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
  def teardown
    teardown_fixture_files
  end
end
