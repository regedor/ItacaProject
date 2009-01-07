class CreateMovieLocals < ActiveRecord::Migration
  def self.up
    create_table :movie_locals do |t|
      t.integer :movie_id
      t.integer :local_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_locals
  end
end
