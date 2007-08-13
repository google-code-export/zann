class Photo < ActiveRecord::Base
  file_column :image, {:root_path => File.join(RAILS_ROOT, "public", "files")} if RAILS_ENV != "test"
  file_column :image, {:root_path => File.join(RAILS_ROOT, "test", "tmp", "file_column", "files")} if RAILS_ENV == "test"
  validates_file_format_of :image, :in => ["gif", "png", "jpg"]
  validates_filesize_of :image, :in => 0..50.megabytes
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :album, :class_name => 'Album', :foreign_key => 'album_id'
  validates_presence_of :name,:created_at
  validates_length_of :name, :maximum => 100
  def zann_count
    Zann.count(:conditions => "zannee_type = 'photo' AND zannee_id = #{id}")
  end
end