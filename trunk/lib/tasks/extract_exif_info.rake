require 'exif_reader'
namespace :zann do
  desc 'extract EXIF info from existing photos'
  task :extract_exif_info => :environment do
    photos = Photo.find(:all)
    for photo in photos
      begin
        puts "Extracting EXIF info for photo #{photo.id}"
        exif = ExifReader.read(photo.image)
        if(exif.length > 0)
          puts "Saving Extracted EXIF record to photo #{photo.id}"
          photo.exif = Exif.new(exif)
          photo.save
        end
      rescue
        puts "[Extracting EXIF info] Failed to extract exif info from photo #{photo.id}"
      end
    end
  end
end