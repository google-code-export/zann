require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  fixtures :comments, :photos, :videos
  
  def setup
    setup_fixture_files
  end

  def test_photo_comments_count
    photo_shanghai = photos(:shanghai_2)
    assert_equal 2, photo_shanghai.comments_count
    comment = Comment.new
    comment.content = 'comments count testing'
    comment.author_id = 3
    comment.comment_object_type = 'photo'
    comment.comment_object_id = photo_shanghai.id
    comment.save
    photo_shanghai.reload
    assert_equal 3, photo_shanghai.comments_count
  end
  
  def test_video_comments_count
    macbook_video = videos(:macbook_in_action)
    assert_equal 0, macbook_video.comments_count
    comment = Comment.new
    comment.content = 'comments count testing'
    comment.author_id = 3
    comment.comment_object_type = 'video'
    comment.comment_object_id = macbook_video.id
    comment.save
    macbook_video.reload
    assert_equal 1, macbook_video.comments_count
  end

  def teardown
    teardown_fixture_files
  end
end
