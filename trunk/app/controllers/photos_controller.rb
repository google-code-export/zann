class PhotosController < ApplicationController
  before_filter :login_required, :except => [ :list, :show]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @photo_pages, @photos = paginate :photos, :per_page => 10
  end

  def show
    @photo = Photo.find(params[:id])
    @photo.view_once if(logged_in? && current_user.id != @photo.creator_id)
    @comments = @photo.find_comments
    #render(:layout => "single_column")
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo])
    @photo.created_at = Time.now
    @photo.creator_id = current_user.id
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :action => 'show', :id => @photo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Photo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def most_viewed
    @photos = Photo.find(:all,  :order => 'view_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  def my
    @photos = Photo.find(:all, :conditions => "creator_id = #{current_user.id}")
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  def user
    @photos = Photo.find(:all, :conditions => "creator_id = #{params[:id]}")
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")    
  end
  def most_zanned
    @photos = Photo.find(:all,  :order => 'zanns_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  def most_commented
    @photos = Photo.find(:all,  :order => 'comments_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
end
