class CreateMusicGenres < ActiveRecord::Migration
  def self.up
    create_table :music_genres do |t|
      t.string :name

      t.integer :user_creator_id
      t.integer :user_updator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :music_genres
  end
end






