class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :user_creator_id
      t.integer :user_updator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
