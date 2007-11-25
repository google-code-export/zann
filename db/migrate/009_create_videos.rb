class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.column :name, :string, :limit => 100
      t.column :description, :string, :limit => 1000
      t.column :creator_id, :integer
      t.column :created_at, :datetime
      t.column :movie, :string, :limit => 200
      t.column :view_count, :integer, :default => 0
      t.column :comments_count, :integer, :default => 0
      t.column :zanns_count, :integer, :default => 0
    end
  end

  def self.down
    drop_table :videos
  end
end
