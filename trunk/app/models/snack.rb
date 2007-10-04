class Snack < ActiveRecord::Base
  acts_as_authorizable
  file_column :image
  validates_file_format_of :image, :in => ["gif", "png", "jpg"]
  validates_filesize_of :image, :in => 0..50.megabytes
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  validates_presence_of :name, :image
  validates_length_of :name, :maximum => 100
  validates_uniqueness_of :name, :case_sensitive => false
end
