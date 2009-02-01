class CreateMovieMovies < ActiveRecord::Migration
  def self.up
    create_table :movie_movies do |t|
      t.integer :movie_id
      t.integer :movie2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_movies
  end
end
