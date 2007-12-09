class SnacksController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @snacks = Snack.find(:all,  :order => 'created_at DESC')
    @snack_pages, @snacks = paginate_collection @snacks, :page => params[:page]
  end

  def new
    @snack = Snack.new
  end
  
  def create
    @snack = Snack.new(params[:snack])
    @snack.creator_id = current_user.id
    if @snack.save
      @snack.accepts_role 'creator', current_user
      flash[:notice] = 'Snack was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def show
    @snack = Snack.find(params[:id])
  end
end
