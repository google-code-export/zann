class Album < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  validates_presence_of :name,:created_at
  validates_length_of :name, :maximum => 100
  validates_length_of :description, :maximum => 1000
end
