class CreateZanns < ActiveRecord::Migration
  def self.up
    create_table :zanns do |t|
      t.column :zanner, :integer
      t.column :zanned_at, :datetime
      t.column :zannee_type, :string, :limit => 20
      t.column :zannee_id, :integer
    end
  end

  def self.down
    drop_table :zanns
  end
end
