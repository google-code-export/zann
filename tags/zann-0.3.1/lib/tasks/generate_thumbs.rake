require 'thumbnail'
include ImageProcessing
namespace :zann do
  desc "generate thumbnails for certain photos"
  task :generate_thumbs => :environment do
    # add photo ids here
    photo_ids = [1, 2]
    photo_ids.each do |id|
      photo = Photo.find(id)
      puts "generating thumbnail for photo #{id.to_s}"
      create_thumb(photo.image)
    end
  end
end
