class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  validates_presence_of :content, :comment_object_type, :comment_object_id
  validates_inclusion_of :comment_object_type, :in => %w{ photo }
  validates_numericality_of :comment_object_id, :only_integer => true
  validates_length_of :content, :maximum => 1000
end
