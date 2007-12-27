class Video < ActiveRecord::Base
  acts_as_authorizable
  file_column :movie, :video => {}
  validates_filesize_of :movie, :in => 0..500.megabytes
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  validates_presence_of :name,:movie
  validates_length_of :name, :maximum => 100
  validates_uniqueness_of :name, :case_sensitive => false

  def zanned_by_user?(user_id)
    zann_count = Zann.count(:conditions => ["zannee_type = 'video' AND zannee_id = ? AND zanner_id = ?", id, user_id])
    return zann_count>0 ? true : false;
  end 
end
