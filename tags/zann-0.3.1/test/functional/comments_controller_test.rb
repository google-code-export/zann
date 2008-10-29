require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_post_photo_comment
    comment_count = Comment.count
    post :new, :comment => {
      :content => 'comment test',
      :comment_object_type => 'photo',
      :comment_object_id => 1
    }
    assert comment_count + 1, Comment.count
  end

  def test_post_video_comment
    comment_count = Comment.count
    post :new, :comment => {
      :content => 'comment test',
      :comment_object_type => 'video',
      :comment_object_id => 1
    }
    assert comment_count + 1, Comment.count
  end
end
