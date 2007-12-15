class CreateLens < ActiveRecord::Migration
  def self.up
    create_table :lenses do |t|
      t.column :name, :string, :limit => 100
      t.column :description, :string, :limit => 500
      t.column :query, :string, :limit => 1000
      t.column :view, :string, :limit => 1000
    end
  end

  def self.down
    drop_table :lenses
  end
end
