class ZannController < ApplicationController
  before_filter :login_required
  def new
    zann_req = {
        :zannee_type => params[:zannee_type],
        :zannee_id => params[:zannee_id],
        :zanner_id => current_user.id}
    unless Zann.exists?(zann_req)
      zann = Zann.new(zann_req.merge({:zanned_at => Time.now}))
      if zann.save!
        flash[:info] = 'Thank you for your voting.'
      else
        flash[:info] = "Zann failed."
      end
    end
    if(params[:zannee_type] == 'photo')
			@photo = Photo.find(params[:zannee_id]) 
			render(:partial => 'photos/zann_counter', :locals => {:photo => @photo})
    elsif(params[:zannee_type] == 'snack')
			@snack = Snack.find(params[:zannee_id]) 
			render(:partial => 'snacks/zann_counter', :locals => {:snack => @snack})
    elsif(params[:zannee_type] == 'video')
			@video = Video.find(params[:zannee_id]) 
			render(:partial => 'videos/zann_counter', :locals => {:video => @video})
    end
  end
end
