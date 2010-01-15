class CreateCountriesAndResources < ActiveRecord::Migration
  def self.up
    create_table :country_photos do |t|
      t.integer :country_id
      t.integer :photo_id
      t.timestamps
    end
    create_table :country_movies do |t|
      t.integer :country_id
      t.integer :movie_id
      t.timestamps
    end
    create_table :country_writen_documents do |t|
      t.integer :country_id
      t.integer :writen_document_id
      t.timestamps
    end
    create_table :country_sound_documents do |t|
      t.integer :country_id
      t.integer :sound_document_id
      t.timestamps
    end
  end

  def self.down
    drop_table :country_sound_documents
    drop_table :country_writen_documents
    drop_table :country_photos
    drop_table :country_movies
  end
end
