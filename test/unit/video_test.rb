require File.dirname(__FILE__) + '/../test_helper'

class VideoTest < Test::Unit::TestCase
  include VideoProcessing
  fixtures :videos
  
  def test_truth
    assert true
  end
end
