namespace :zann do
  desc 'import data from production system'
  task :import_data => :environment do
    # 1. for each huangshan outing album, tag the photos
    # 2. tag photos in wangting's baby
    # 3. tag meeting rooms photos
    # 4. create a new album called outing
    # 5. move all the huangshan outing photos to outing album
    # 6. rename Ting's baby album to baby
    puts "tagging album pine"
    tag_photos_in_album(1, '2007 huangshan outing pine')
    puts "tagging album rock"
    tag_photos_in_album(2, '2007 huangshan outing rock')
    puts "tagging album character"
    tag_photos_in_album(3, '2007 huangshan outing character')
    puts "tagging album group"
    tag_photos_in_album(4, '2007 huangshan outing group')
    puts "tagging album image_processing"
    tag_photos_in_album(5, '2007 huangshan outing image_processing')
    puts "tagging album others"
    tag_photos_in_album(6, '2007 huangshan outing')
    puts "tagging album meeting_rooms"
    tag_photos_in_album(7, 'meeting_rooms')
    puts "tagging album ting's baby girl"
    tag_photos_in_album(8, 'baby girl wangting')
    puts "creating new album for outing"
    outing_album = Album.new(
      :name => 'Outing',
      :description => '读万卷书,行万里路. A true scholar balances himself by indoor learning and outdoor practices :p',
      :creator_id => 1,
      :photos_count => 0
    )
    outing_album.save
    puts "move all huangshan photos to outing album"
    photos = Photo.find(:all, :conditions => ["album_id <> 7 AND album_id <> 8"])
    for photo in photos
      photo.album = outing_album
      photo.save
    end
  end

  private
  def tag_photos_in_album(album_id, tag_list)
    photos = Photo.find(:all, :conditions => ["album_id = ?", album_id])
    for photo in photos
      photo.tag_with(tag_list)
    end
  end
end