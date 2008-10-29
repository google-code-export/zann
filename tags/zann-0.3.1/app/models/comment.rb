class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  validates_presence_of :content, :comment_object_type, :comment_object_id
  validates_inclusion_of :comment_object_type, :in => %w{ photo video}
  validates_numericality_of :comment_object_id, :only_integer => true
  validates_length_of :content, :maximum => 1000
  @@comment_object_types = {
    'photo' => Photo,
    'video' => Video
  }

  def after_save
    comment_object_class = @@comment_object_types[self.comment_object_type]
    comment_object = comment_object_class.find(self.comment_object_id)
    comment_object.update_attribute('comments_count', comment_object.comments_count + 1)
  end
end
