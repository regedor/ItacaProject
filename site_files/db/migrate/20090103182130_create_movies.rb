class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string    :title
      t.integer   :genre_id
      t.text      :synopsis
      t.integer   :author_id
      t.integer   :director_id
      t.string    :producer
      t.integer   :production_year
      t.integer   :release_date
      t.text      :main_event       
      t.text      :cultural_context 
      t.text      :image_sound      
      t.text      :ccdc             
      t.text      :reading          
      t.text      :exploration      
      t.text      :analisis         
      t.text      :proposals        
      t.text      :production_context
      t.text      :comments
      t.string    :distributor
      t.integer   :duration
      t.string    :format
      t.integer   :category_id
      t.integer   :subcategory_1_id
      t.integer   :subcategory_2_id
      t.integer   :subcategory_3_id
      t.integer   :subcategory_4_id
      t.boolean   :free
      t.string    :rights
      t.string    :youtube_link

      t.integer    :user_creator_id
      t.integer    :user_updator_id
      t.integer    :status, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
