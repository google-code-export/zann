require 'thumbnail'
module AlbumsHelper
  include ImageProcessing
  def album_cover(album)
    cover = album.album_cover_photo
    if cover.nil?
      'album_icon.gif' 
    else
      small_size_file_url(cover,'image')
    end
  end
end
