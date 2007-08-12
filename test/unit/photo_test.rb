require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < Test::Unit::TestCase
  fixtures :photos, :zanns

  def test_zann_count
    assert_equal 2, photos(:shanghai_1).zann_count
    assert_equal 0, photos(:cat_9).zann_count
  end
end
