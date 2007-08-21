class Photo < ActiveRecord::Base
  file_column :image
  validates_file_format_of :image, :in => ["gif", "png", "jpg"]
  validates_filesize_of :image, :in => 0..50.megabytes
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :album, :class_name => 'Album', :foreign_key => 'album_id'
  validates_presence_of :name,:created_at
  validates_length_of :name, :maximum => 100
  def find_comments
    Comment.find(:all, :conditions => "comment_object_type = 'photo' AND comment_object_id = #{id}")
  end
  def view_once
    self.view_count = self.view_count + 1
    self.save
  end
  #def zanns_count
   # Zann.count(:conditions => "zannee_type = 'photo' AND zannee_id = #{id}")
  #end
  #def comments_count
   # Comment.count(:all, :conditions => "comment_object_type = 'photo' AND comment_object_id = #{id}")
  #end
  def zanned_by_user?(user_id)
    zann_count = Zann.count(:conditions => "zannee_type = 'photo' AND zannee_id = #{id} AND zanner_id = #{user_id}")
    return zann_count>0 ? true : false;
  end
end
