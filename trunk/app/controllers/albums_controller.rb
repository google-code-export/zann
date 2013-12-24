class AlbumsController < ApplicationController
  before_filter :login_required, :except => [ :list, :show, :gallery, :slideshow, :data]
  permit 'admin', :only => [:new, :edit, :create, :update, :destroy, :admin]
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @albums = Album.find(:all,  :order => 'created_at DESC')
    @album_pages, @albums = paginate_collection @albums, :page => params[:page], :per_page => 10
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
      format.js { 
        if(params[:gallery])
          render :template => "albums/data_gallery_js", :layout => false
        else
          render :template => "albums/data_slideshow_js", :layout => false
        end
      }
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

  # album admin mgmt page
  def admin
    @albums = Album.find(:all)
  end

  def grant
    album = Album.find(params[:album_id])
    admin = User.find_by_email(params[:admin_email])
    if(admin.nil?)
      flash[:warning] = "There's no user with email '#{params[:admin_email]}'"
      redirect_to :action => 'admin' 
    else
      album.accepts_role 'album_admin', admin
      flash[:notice] = "#{admin.full_name} is added as admin of album '#{album.name}'"
      redirect_to :action => 'admin' 
    end
  end

  def ungrant
    album = Album.find(params[:album_id])
    admin = User.find_by_email(params[:admin_email])
    album.accepts_no_role 'album_admin', admin
    flash[:notice] = "#{admin.full_name} is removed from admin list of album '#{album.name}'"
    redirect_to :action => 'admin' 
  end

  def reset_zanns_count
    @album = Album.find(params[:id])
    permit "album_admin of :album" do
      @album.reset_zanns_count
      flash[:notice] = "Zann count of photos in album #{album.name} are successfully reset. "
      redirect_to :action => 'list'
    end
  end

  def ranked_photos
    @album = Album.find(params[:id])
    @photos = @album.ranked_photos
  end

  private
  def find_photos_in_album
    if(params[:tag].nil?)
      @photos = Photo.find_all_by_album_id(params[:id].to_i) 
      @photo_pages, @photos = paginate_collection @photos, :page => params[:page], :per_page => 48
    else
      @photos = Photo.find_by_album_and_tag(params[:id].to_i, params[:tag])
    end
  end
  
end
