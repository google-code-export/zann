class ZannController < ApplicationController
  before_filter :login_required
  def new
    @zann = Zann.new
    @zann.zannee_type = params[:zannee_type]
    @zann.zannee_id = params[:zannee_id]
    @zann.zanned_at = Time.now
    @zann.zanner_id = current_user.id
    if @zann.save
      flash[:notice] = 'Zann succeeded.'
    else
      flash[:warning] = 'Zann failed.'
    end
    render(:nothing => true)
  end
end
