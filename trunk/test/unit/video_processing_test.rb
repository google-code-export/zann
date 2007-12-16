require File.dirname(__FILE__) + '/../test_helper'

class VideoProcessingTest < Test::Unit::TestCase
  include VideoProcessing

  def test_convert_video
    video_dir = File.join(RAILS_ROOT, 'test', 'unit', 'data')
    convert_video(File.join(video_dir, 'macbook.avi'))
    assert File.exist?(File.join(video_dir, 'macbook.flv'))
    File.delete(File.join(video_dir, 'macbook.flv'))
    assert File.exist?(File.join(video_dir, 'macbook.png'))
    File.delete(File.join(video_dir, 'macbook.png'))
  end
end
