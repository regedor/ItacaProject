class AddUserProfileField < ActiveRecord::Migration
  def self.up
    add_column :users, :profile, :string
  end

  def self.down
    remove_column :users, :profile
  end
end
