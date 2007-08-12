class Zann < ActiveRecord::Base
  belongs_to :zanner, :class_name => 'User', :foreign_key => 'zanner_id'
end
