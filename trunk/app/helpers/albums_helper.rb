require 'thumbnail'
module AlbumsHelper
  include ImageProcessing
  def album_cover(album)
    cover = album.album_cover_photo
    if cover.nil?
      'album_icon.gif' 
    else
      url_for_file_column(cover,'image')
    end
  end
end
