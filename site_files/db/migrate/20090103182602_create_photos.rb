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
      t.integer  :subcategory_1_id
      t.integer  :subcategory_2_id
      t.integer  :subcategory_3_id
      t.integer  :subcategory_4_id
      t.boolean  :free
      t.string   :rights

      t.string   :filename
      t.string   :version_name
      t.string   :content_type
      t.integer  :file_size
      t.integer  :base_version_id
      t.integer  :photo_owner_id
      t.string   :photo_owner_type

      t.integer  :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
