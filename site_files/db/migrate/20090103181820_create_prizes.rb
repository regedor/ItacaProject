class CreatePrizes < ActiveRecord::Migration
  def self.up
    create_table :prizes do |t|
      t.string :title
      t.text :description
      t.integer :user_creator_id
      t.integer :user_updator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :prizes
  end
end
