class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.integer :genre_id
      t.text :synopsis
      t.integer :author_id
      t.integer :director_id
      t.string :producer
      t.integer :production_year
      t.integer :release_date
      t.integer :local_id
      t.text :comments
      t.text :production_context
      t.string :distributor
      t.integer :duration
      t.string :format
      t.integer :category_id
      t.integer :category_id1
      t.integer :category_id2
      t.integer :category_id3
      t.integer :category_id4
      t.boolean :free
      t.string :rights

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
