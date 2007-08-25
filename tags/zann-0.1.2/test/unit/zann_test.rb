require File.dirname(__FILE__) + '/../test_helper'

class ZannTest < Test::Unit::TestCase
  fixtures :zanns, :photos
  
  def setup
    setup_fixture_files
  end

  def test_zanns_count
    photo_shanghai = photos(:shanghai_1)
    assert_equal 2, photo_shanghai.zanns_count
    zann = Zann.new
    zann.zanner_id = 3
    zann.zanned_at = Time.now
    zann.zannee_type = 'photo'
    zann.zannee_id = 1
    zann.save
    photo_shanghai = Photo.find(photo_shanghai.id)
    assert_equal 3, photo_shanghai.zanns_count
  end
  
  def teardown
    teardown_fixture_files
  end
end
