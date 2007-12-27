namespace :zann do
  desc "copy file fixtures from testing fixtures directory to public directory"
  task :load_fixture_files do
    puts 'loading fixture files'
    tmp_path = File.join(RAILS_ROOT, "public", "photo")
    file_fixtures = Dir.glob File.join(RAILS_ROOT, "test", "fixtures", "file_column", "photo", "*")

    FileUtils.mkdir_p tmp_path unless File.exists?(tmp_path)
    FileUtils.cp_r file_fixtures, tmp_path

    tmp_path = File.join(RAILS_ROOT, "public", "video")
    file_fixtures = Dir.glob File.join(RAILS_ROOT, "test", "fixtures", "file_column", "video", "*")
    
    FileUtils.mkdir_p tmp_path unless File.exists?(tmp_path)
    FileUtils.cp_r file_fixtures, tmp_path
    puts 'fixture file loading done.'
  end

  desc "remove existing uploaded files"
  task :remove_uploaded_files do
    uploaded_photos = File.join(RAILS_ROOT, "public", "photo")
    puts uploaded_photos
    FileUtils.remove_dir uploaded_photos, :verbose => true
    uploaded_videos = File.join(RAILS_ROOT, "public", "video")
    FileUtils.remove_dir uploaded_videos, :verbose => true
  end
end