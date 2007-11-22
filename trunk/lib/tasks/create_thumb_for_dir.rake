require 'thumbnail'
include ImageProcessing
desc "create thumbnails for images in one directory"
task :create_thumb_for_dir do
  create_thumbnail_for_dir(File.join(RAILS_ROOT, 'test', 'fixtures', 'file_column'))
end
private
def create_thumbnail_for_dir(dir)
  Dir.foreach(dir) { |filename|
   if not ['.', '..', '.svn'].include? filename
     full_file_name = File.join(dir, filename)
     if(File.directory?(full_file_name))
       puts "create_thumbnail_for_dir #{full_file_name}"
       create_thumbnail_for_dir(full_file_name)
     else
       puts "create_thumb #{full_file_name}"
       create_thumb(full_file_name)
     end
   end
  }
end

