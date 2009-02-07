class CreateSubcategories < ActiveRecord::Migration
  def self.up
    create_table :subcategories do |t|
      t.string :name
      t.string :description

      t.integer :user_creator_id
      t.integer :user_updator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :subcategories
  end
end
