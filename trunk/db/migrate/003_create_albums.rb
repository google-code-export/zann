class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.column :name, :string, :limit => 100
      t.column :description, :string, :limit => 1000
      t.column :creator_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :albums
  end
end
