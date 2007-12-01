class AlbumsController < ApplicationController
  before_filter :login_required, :except => [ :list, :show, :gallery, :slideshow, :data]
  permit 'admin', :only => [:new, :edit, :create, :update, :destroy]
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @album_pages, @albums = paginate :albums, :per_page => 10
  end

  def show
    @album = Album.find(params[:id])
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(params[:album])
    @album.creator_id = current_user.id
    @album.created_at = Time.now
    if @album.save
      flash[:notice] = 'Album was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params[:album])
      flash[:notice] = 'Album was successfully updated.'
      redirect_to :action => 'show', :id => @album
    else
      render :action => 'edit'
    end
  end

  def destroy
    Album.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #TODO add a functional test
  def data
    find_photos_in_album
    @album = Album.find(params[:id])
    @tags = @album.find_tags_in_album
    respond_to do |format|
      format.html
      format.json { render :template => "albums/_data_json", :layout => false }
      format.js { render :template => "albums/data_js", :layout => false }
    end
  end
  
  def gallery
    find_photos_in_album
    @album = Album.find(params[:id])
    @tags = @album.find_tags_in_album
  end
  
  def slideshow
    find_photos_in_album
    @album = Album.find(params[:id])
    @not_require_prototype = true
  end

  private
  def find_photos_in_album
    if(params[:tag].nil?)
      @photos = Photo.find_all_by_album_id(params[:id].to_i) 
    else
      @photos = Photo.find_by_album_and_tag(params[:id].to_i, params[:tag])
    end
  end
  
end
