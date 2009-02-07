class CreateLocals < ActiveRecord::Migration
  def self.up
    create_table :locals do |t|
      t.string  :name
      t.integer :country_id
      t.string  :description
      t.integer :user_creator_id
      t.integer :user_updator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :locals
  end
end
