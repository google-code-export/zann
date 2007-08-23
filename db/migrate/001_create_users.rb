require 'rubygems'
require 'active_record/fixtures'
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :first_name, :string, :limit => 100
      t.column :last_name, :string, :limit => 100
      t.column :avatar, :string, :limit => 200
    end
    fixture = Fixtures.new(User.connection, # a database connection
                     "users" , # table name
                     User, # model class
                     File.join(File.dirname(__FILE__), "data/users" ))
    fixture.insert_fixtures
  end

  def self.down
    drop_table "users"
  end
end
