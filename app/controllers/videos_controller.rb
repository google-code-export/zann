class VideosController < ApplicationController
  before_filter :login_required, :except => [ :list, :show, :user, :tag]
  def index
    list
    render :action => 'list'
  end

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  def list
    @videos = Video.find(:all,  :order => 'created_at DESC')
    @video_pages, @videos= paginate_collection @videos, :page => params[:page]
  end

  def show
    @video = Video.find(params[:id])
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    @video.creator_id = current_user.id
    if @video.save
      @video.accepts_role 'creator', current_user
			@video.tag_with(params[:tag_list]) if !params[:tag_list].nil?
      flash[:notice] = 'Video was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @video = Video.find(params[:id])
    @tag_list = @video.tag_list
    permit "creator of :video" do
    end
  end

  def update
    @video = Video.find(params[:id])
    permit "creator of :video" do
      if @video.update_attributes(params[:video])
        @video.tag_update(params[:tag_list].nil?()?'':params[:tag_list])
        flash[:notice] = 'Video was successfully updated.'
        redirect_to :action => 'show', :id => @video
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @video = Video.find(params[:id])
    permit "creator of :video" do
      # destroy all records related with this video
      @video.destroy
      flash[:notice] = 'Video was successfully deleted.'
      redirect_to :action => 'list'
    end
  end
end
