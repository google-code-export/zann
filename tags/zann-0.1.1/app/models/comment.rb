class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  validates_presence_of :content, :comment_object_type, :comment_object_id
  validates_inclusion_of :comment_object_type, :in => %w{ photo }
  validates_numericality_of :comment_object_id, :only_integer => true
  validates_length_of :content, :maximum => 1000
  def after_save
    if(self.comment_object_type == 'photo')
      photo = Photo.find(self.comment_object_id)
      photo.comments_count = photo.comments_count + 1
      photo.save
    end
  end
end
