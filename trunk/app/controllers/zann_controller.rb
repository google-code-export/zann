class ZannController < ApplicationController
  before_filter :login_required
  def new
    zann = Zann.new({:zannee_type => params[:zannee_type],
		     :zannee_id => params[:zannee_id],
		     :zanned_at => Time.now,
		     :zanner_id => current_user.id})
    if zann.save
      flash[:info] = 'Thank you for your voting.'
    else
      flash[:info] = "Zann failed. You're allowed to vote for one photo only once."
    end
    if(params[:zannee_type] == 'photo')
	@photo = Photo.find(params[:zannee_id]) 
	render(:partial => 'photos/zann_counter', :locals => {:photo => @photo})
    elsif(params[:zannee_type] == 'snack')
	@snack = Snack.find(params[:zannee_id]) 
	render(:partial => 'snacks/zann_counter', :locals => {:snack => @snack})
    end
  end
end
