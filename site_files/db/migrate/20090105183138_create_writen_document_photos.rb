class CreateWritenDocumentPhotos < ActiveRecord::Migration
  def self.up
    create_table :writen_document_photos do |t|
      t.integer :writen_document_id
      t.integer :photo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :writen_document_photos
  end
end
