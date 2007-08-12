class ZannController < ApplicationController
  before_filter :login_required
  def new
    zann = Zann.new
    zann.zannee_type = params[:zannee_type]
    zann.zannee_id = params[:zannee_id]
    zann.zanned_at = Time.now
    zann.zanner_id = current_user.id
    if zann.save
      flash[:info] = 'Thank you for your voting.'
    else
      flash[:info] = "Zann failed. You're allowed to vote for one photo only once."
    end
    @photo = Photo.find(params[:zannee_id]) if(params[:zannee_type] == 'photo')
    render(:layout => false, :template => 'photos/zann_counter')
  end
end
