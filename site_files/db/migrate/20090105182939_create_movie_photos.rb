class CreateMoviePhotos < ActiveRecord::Migration
  def self.up
    create_table :movie_photos do |t|
      t.integer :movie_id
      t.integer :photo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_photos
  end
end
