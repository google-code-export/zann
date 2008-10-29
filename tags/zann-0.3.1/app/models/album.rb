class Album < ActiveRecord::Base
  acts_as_authorizable
  has_many :photo
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  validates_presence_of :name,:created_at
  validates_length_of :name, :maximum => 100
  validates_length_of :description, :maximum => 1000
  validates_uniqueness_of :name, :case_sensitive => false
  def album_cover_photo
    Photo.find(:first, :conditions => ["album_id = ?", id])
  end

  def winner_photo
    Photo.find(:first, :conditions => ["album_id = ?", id ], :order => "zanns_count DESC")
  end

  def find_tags_in_album
    Tag.find(:all,
      :select => 'tags.name, count(*) as popularity',
      :joins => 'JOIN taggings ON tags.id = taggings.tag_id 
      JOIN photos ON taggings.taggable_id = photos.id',
      :conditions => ["photos.album_id = ? AND taggings.taggable_type = ?", id, 'Photo'],
      :group => 'tags.name'
    )
  end

  def admins
    User.find_by_sql(
      "SELECT users.* 
      FROM users
      WHERE users.id in (
        SELECT roles_users.user_id
        FROM roles_users JOIN roles ON roles.id = roles_users.role_id
        WHERE roles.authorizable_type = 'Album' 
        AND roles.authorizable_id = #{self.id}
        AND roles.name = 'album_admin'
      )"
    )
  end

  def reset_zanns_count
    Photo.update_all("zanns_count = 0", "album_id = #{self.id}")
  end
end
