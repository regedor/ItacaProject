class CreateMovieSoundDocuments < ActiveRecord::Migration
  def self.up
    create_table :movie_sound_documents do |t|
      t.integer :movie_id
      t.integer :sound_document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_sound_documents
  end
end
