class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :author_id, :integer
      t.column :content, :string, :limit => 1000
      t.column :created_at, :datetime
      t.column :comment_object_type, :string, :limit => 100
      t.column :comment_object_id, :integer
    end
  end

  def self.down
    drop_table :comments
  end
end
