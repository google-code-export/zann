class Zann < ActiveRecord::Base
  belongs_to :zanner, :class_name => 'User', :foreign_key => 'zanner_id'
  validates_presence_of :zannee_id
  validates_inclusion_of :zannee_type, :in => %w{ photo }
  validates_numericality_of :zannee_id, :only_integer => true
end
