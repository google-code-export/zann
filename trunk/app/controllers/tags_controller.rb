class TagsController < ApplicationController
  def photo_tag_cloud
    @cloud = Tag.cloud(:conditions => "taggings.taggable_type = 'Photo'")
  end

  def snack_tag_cloud
    @cloud = Tag.cloud(:conditions => "taggings.taggable_type = 'Snack'")
  end

end
