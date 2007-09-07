desc "copy file fixtures from testing fixtures directory to public directory"
task :load_fixture_files do
  puts 'load fixture files'
  tmp_path = File.join(RAILS_ROOT, "public", "photo")
  file_fixtures = Dir.glob File.join(RAILS_ROOT, "test", "fixtures", "file_column", "photo", "*")
  
  FileUtils.mkdir_p tmp_path unless File.exists?(tmp_path)
  FileUtils.cp_r file_fixtures, tmp_path
end