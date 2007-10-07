class SnacksController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @snacks = Snack.find(:all,  :order => 'created_at DESC')
    @snack_pages, @snacks = paginate_collection @snacks, :page => params[:page]
  end
  
end
