require File.dirname(__FILE__) + '/../test_helper'

class ZannTest < ActiveSupport::TestCase
  fixtures :zanns, :photos
  
  def setup
    setup_fixture_files
  end

  def test_zanns_count
    photo_shanghai = photos(:shanghai_1)
    assert_equal 2, photo_shanghai.zanns_count
    zann = Zann.new({:zanner_id => 3, 
		     :zanned_at => Time.now,
		     :zannee_type => 'photo',
		     :zannee_id => 1 })
    assert zann.save
    photo_shanghai = Photo.find(photo_shanghai.id)
    assert_equal 3, photo_shanghai.zanns_count
  end
  
  def teardown
    teardown_fixture_files
  end
end
