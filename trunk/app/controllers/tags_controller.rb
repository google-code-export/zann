class TagsController < ApplicationController
  def photo
    @cloud = Tag.cloud(:conditions => "taggings.taggable_type = 'Photo'")
  end

  def snack
    @cloud = Tag.cloud(:conditions => "taggings.taggable_type = 'Snack'")
  end
end
