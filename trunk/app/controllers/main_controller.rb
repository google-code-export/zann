class MainController < ApplicationController
  def welcome
    render 
  end
  
  def statistics
    @total_users = User.count
    @photo_owners = User.count("users.id in (SELECT creator_id FROM photos)")
    @photo_zanners = User.count("users.id in (SELECT zanner_id FROM zanns)") 
    @total_zanns = Zann.count
    @total_photos = Photo.count
    render :layout => false
  end
end
