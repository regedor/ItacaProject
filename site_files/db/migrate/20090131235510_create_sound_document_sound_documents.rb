class CreateSoundDocumentSoundDocuments < ActiveRecord::Migration
  def self.up
    create_table :sound_document_sound_documents do |t|
      t.integer :sound_document_id
      t.integer :sound_document2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sound_document_sound_documents
  end
end
