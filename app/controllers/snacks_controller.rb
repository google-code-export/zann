class SnacksController < ApplicationController
  def list
    @snacks = Snack.find(:all,  :order => 'created_at DESC')
    @snack_pages, @snacks = paginate_collection @snacks, :page => params[:page]
  end

  def filter
    
  end
end
