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
      t.text      :comments
      t.text      :production_context
      t.string    :distributor
      t.integer   :duration
      t.string    :format
      t.integer   :category_id
      t.integer   :category_1_id
      t.integer   :category_2_id
      t.integer   :category_3_id
      t.integer   :category_4_id
      t.boolean   :free
      t.string    :rights
      t.string    :youtube_link

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
