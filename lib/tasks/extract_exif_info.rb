require 'exif_reader'
namespace :zann do
  desc 'extract EXIF info from existing photos'
  task :extract_exif_info do
    photos = Photo.find(:all)
    for photo in photos
      begin
        exif = ExifReader.read(photo.image)
        if(exif != {})
          photo.exif = Exif.new(exif)
          photo.save
        end
      rescue
        logger.error("[Extracting EXIF info] Failed to extract exif info from photo #{photo.id}")
      end
    end
  end
end