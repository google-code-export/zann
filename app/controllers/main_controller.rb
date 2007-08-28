class MainController < ApplicationController
  def welcome
    render 
  end
  
  def dashboard
    User.count(:conditions => '')
  end
end