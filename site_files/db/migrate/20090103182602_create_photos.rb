class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string   :title
      t.text     :synopsis
      t.integer  :author_id
      t.string   :editor
      t.integer  :production_year
      t.text     :comments
      t.text     :production_context
      t.string   :distributor
      t.string   :format
      t.integer  :category_id
      t.integer   :subcategory_1_id
      t.integer   :subcategory_2_id
      t.integer   :subcategory_3_id
      t.integer   :subcategory_4_id
      t.boolean  :free
      t.string   :rights

      t.integer :user_creator_id
      t.integer :user_updator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
