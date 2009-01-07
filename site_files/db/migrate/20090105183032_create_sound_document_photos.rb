class CreateSoundDocumentPhotos < ActiveRecord::Migration
  def self.up
    create_table :sound_document_photos do |t|
      t.integer :sound_document_id
      t.integer :photo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sound_document_photos
  end
end
