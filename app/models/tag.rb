class Tag < ActiveRecord::Base
	has_many_polymorphs :taggables, 
    :from => [:photos, :snacks], 
    :through => :taggings,
    :dependent => :destroy

  def self.cloud(args = {})
    find(:all, 
      :select => 'tags.*, count(*) as popularity',
      :limit => args[:limit] || 5,
      :joins => 'JOIN taggings ON taggings.tag_id = tags.id',
      :conditions => args[:conditions],
      :group => 'taggings.tag_id',
      :order => 'popularity DESC'
    )
  end
end
