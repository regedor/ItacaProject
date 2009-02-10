class CreateMoviePrizes < ActiveRecord::Migration
  def self.up
    create_table :movie_prizes do |t|
      t.integer :movie_id
      t.integer :prize_id
      t.string  :description

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_prizes
  end
end
