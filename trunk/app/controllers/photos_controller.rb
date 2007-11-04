class PhotosController < ApplicationController
  before_filter :login_required, :except => [ :list, :show, :top_viewed, :top_zanned, :top_commented, :top_scored, :winner_photos, :photo_growth, :user, :my]
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @photos = Photo.find(:all,  :order => 'created_at DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
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
  
  def add
    @photo = Photo.new({:album_id => params[:album_id]})
    render :action => 'new'
  end
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.created_at = Time.now
    @photo.creator_id = current_user.id
    if @photo.save
      @photo.accepts_role 'creator', current_user
			@photo.tag_with(params[:tag_list]) if !params[:tag_list].nil?
      flash[:notice] = 'Photo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @photo = Photo.find(params[:id])
    @tag_list = @photo.tag_list
    permit "creator of :photo" do
    end
  end

  def update
    @photo = Photo.find(params[:id])
    permit "creator of :photo" do
      if @photo.update_attributes(params[:photo])
        @photo.tag_update(params[:tag_list].nil?()?'':params[:tag_list])
        flash[:notice] = 'Photo was successfully updated.'
        redirect_to :action => 'show', :id => @photo
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    permit "creator of :photo" do
      # destroy all records related with this photo      
      @photo.destroy
      flash[:notice] = 'Photo was successfully deleted.'
      redirect_to :action => 'list'
    end
  end
  
  def top_viewed
    @photos = Photo.find(:all,  :order => 'view_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  
  def my
    @photos = Photo.find(:all, :conditions => ["creator_id = ?", current_user.id])
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  
  def user
    @photos = Photo.find(:all, :conditions => ["creator_id = ?", params[:id].to_i])
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")    
  end
  
  def top_zanned
    @photos = Photo.find(:all,  :order => 'zanns_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  
  def top_commented
    @photos = Photo.find(:all,  :order => 'comments_count DESC')
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
  
  def top_scored
    @photos = Photo.top_scored
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:layout => false)
  end
  
  def winner_photos
    albums = Album.find(:all)
    @winner_photos = []
    for album in albums
      album_winner_photo = album.winner_photo
      @winner_photos << album_winner_photo if !album_winner_photo.nil?
    end
    render(:layout => false)
  end
  
  def photo_growth
    today = Time.now
    @photos_count_today = Photo.photos_count_until_day(today)
    @photos_count_one_days_ago = Photo.photos_count_until_day(1.days.ago(today))
    @photos_count_two_days_ago = Photo.photos_count_until_day(2.days.ago(today))
    @photos_count_three_days_ago = Photo.photos_count_until_day(3.days.ago(today))
    @photos_count_four_days_ago = Photo.photos_count_until_day(4.days.ago(today))
    @photos_count_five_days_ago = Photo.photos_count_until_day(5.days.ago(today))
    @photos_count_six_days_ago = Photo.photos_count_until_day(6.days.ago(today))    
    render(:layout => false)
  end

  def tag
    @photos = Photo.find_by_tag(params[:id])
    @photo_pages, @photos = paginate_collection @photos, :page => params[:page]
    render(:template => "photos/list")
  end
end
