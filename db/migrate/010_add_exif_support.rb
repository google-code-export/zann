class AddExifSupport < ActiveRecord::Migration
  def self.up
    create_table :exifs do |t|
      t.column :make, :string, :limit => 100
      t.column :model, :string, :limit => 100
      t.column :fnumber, :string, :limit => 50
      t.column :software, :string, :limit => 100
      t.column :exposure_time, :string, :limit => 50
      t.column :flash, :string, :limit => 10
      t.column :focal_length, :string, :limit => 50
      t.column :white_balance, :string, :limit => 10
      t.column :pixel_x_dimension, :string, :limit => 10
      t.column :pixel_y_dimension, :string, :limit => 10
      t.column :date_time, :string, :limit => 100
      t.column :photo_id, :integer
    end

  end

  def self.down
    drop_table :exifs
  end
end
