class CreateSoundDocuments < ActiveRecord::Migration
  def self.up
    create_table :sound_documents do |t|
      t.string   :title
      t.text     :synopsis
      t.integer  :author_id
      t.integer  :director_id
      t.string   :producer
      t.integer  :production_year
      t.integer  :release_date
      t.text     :comments
      t.text     :production_context
      t.string   :distributor
      t.integer  :duration
      t.string   :format
      t.integer  :category_id
      t.integer  :subcategory_1_id
      t.integer  :subcategory_2_id
      t.integer  :subcategory_3_id
      t.integer  :subcategory_4_id
      t.boolean  :free
      t.string   :rights
      t.integer  :music_genre_id
      t.string   :youtube_link

      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sound_documents
  end
end
