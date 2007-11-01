require 'has_many_polymorphs'
class ActiveRecord::Base
  def tag_with tags
    tags.split(" ").each do |tag|
      Tag.find_or_create_by_name(tag).taggables << self
    end
  end

  def tag_list
    tags.map(&:name).join(' ')
  end

	def tag_delete tag_string
		split = tag_string.split(" ")
		tags.delete tags.select{|t| split.include? t.name}
	end

  def tag_update tag_string
    # delete all and add all
    tag_delete tag_list
    tag_with tag_string
    # TODO performance improvement
    # delete unexisting tags
    # add new tags
  end
end