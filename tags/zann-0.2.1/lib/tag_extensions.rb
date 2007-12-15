#gem 'has_many_polymorphs'
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
  
  # return a list of model objects which are tagged by some tags
  def self.find_by_tag(tag_string, filter = nil)
    filter = filter.nil?()?"":" AND #{filter} "
    tag_array = tag_string.split(" ")
    tagged_objects = []
    if(tag_array.length == 1)
      tagged_objects = self.find(:all, 
        :select => "DISTINCT #{self.table_name}.*",
        :joins => "JOIN taggings ON taggings.taggable_type = '#{self.name}' 
                 AND #{self.table_name}.id = taggings.taggable_id 
                 JOIN tags ON taggings.tag_id = tags.id",
        :conditions => ["tags.name = ? #{filter}", tag_array[0]])
    elsif(tag_array.length > 1)
      tag_name_filter = tag_array.map() { |tag|
        tag = "tags.name = '#{tag}'"
      }.join(" OR ")

      find_by_multiple_tags_query = "
        SELECT #{self.table_name}.*
        FROM #{self.table_name}
        WHERE id IN
        (
          SELECT taggables.id
          FROM(
            SELECT #{self.table_name}.*
            FROM #{self.table_name}
            JOIN taggings ON taggings.taggable_type = '#{self.name}' 
            AND #{self.table_name}.id = taggings.taggable_id 
            JOIN tags ON taggings.tag_id = tags.id
            WHERE #{tag_name_filter}
          ) AS taggables 
          GROUP BY taggables.id 
          HAVING count(taggables.id) = #{tag_array.length}
        )
        #{filter}
      "
      tagged_objects = self.find_by_sql(self.sanitize_sql(find_by_multiple_tags_query))
    end
    return tagged_objects
  end
end