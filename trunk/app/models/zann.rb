class Zann < ActiveRecord::Base
  belongs_to :zanner, :class_name => 'User', :foreign_key => 'zanner_id'
  validates_presence_of :zannee_id
  validates_inclusion_of :zannee_type, :in => %w{ photo snack }
  validates_numericality_of :zannee_id, :only_integer => true
  @@zannee_types = {
    'photo' => Photo,
    'snack' => Snack
  }
  def after_save
    zannee_class = @@zannee_types[self.zannee_type]
    zannee = zannee_class.find(self.zannee_id)
    zannee.update_attribute('zanns_count', zannee.zanns_count + 1)
  end
end
