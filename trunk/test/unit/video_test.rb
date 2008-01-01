require File.dirname(__FILE__) + '/../test_helper'

class VideoTest < Test::Unit::TestCase
  include VideoProcessing
  fixtures :videos
  
  def test_tagging_video
    macbook_video = videos(:macbook_in_action)
    macbook_video.tag_with('macbook video')
    assert macbook_video.tag_list.include?('macbook')
    assert macbook_video.tag_list.include?('video')
  end

  def test_find_video_by_tag
    macbook_video = videos(:macbook_in_action)
    macbook_video.tag_with('macbook video')
    @videos = Video.find_by_tag('macbook')
    assert_equal 1, @videos.length
  end
end
