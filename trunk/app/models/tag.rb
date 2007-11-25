class Tag < ActiveRecord::Base
	has_many_polymorphs :taggables, 
    :from => [:photos, :snacks], 
    :through => :taggings,
    :dependent => :destroy

  def self.cloud(args = {})
    find(:all, 
      :select => 'tags.name, count(*) as popularity',
      :limit => args[:limit] || 1000,
      :joins => 'JOIN taggings ON taggings.tag_id = tags.id',
      :conditions => args[:conditions],
      :group => 'tags.name',
      :order => 'popularity DESC'
    )
  end
end
