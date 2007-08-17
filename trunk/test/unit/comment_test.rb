require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments, :photos
  
  def setup
    setup_fixture_files
  end

  def test_comments_count
    photo_shanghai = photos(:shanghai_2)
    assert_equal 2, photo_shanghai.comments_count
    comment = Comment.new
    comment.content = 'comments count testing'
    comment.author_id = 3
    comment.comment_object_type = 'photo'
    comment.comment_object_id = 2
    comment.save
    photo_shanghai = Photo.find(photo_shanghai.id)
    assert_equal 3, photo_shanghai.comments_count
  end
  
  def teardown
    teardown_fixture_files
  end
end
