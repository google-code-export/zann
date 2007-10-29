class Tag < ActiveRecord::Base
	has_many_polymorphs :taggables, 
    :from => [:photos, :snacks], 
    :through => :taggings,
    :dependent => :destroy
end
