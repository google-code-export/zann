class CommentsController < ApplicationController
  before_filter :login_required, :only => [:new]
  def new
    @comment = Comment.new(params[:comment])
    @comment.author_id = current_user.id
    if @comment.save
#      flash[:notice] = "Thank for your comments."
    end    
    render(:partial => 'comments/comment', :locals => {:comment => @comment})
  end
end
