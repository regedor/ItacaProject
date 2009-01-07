class CreateSoundDocumentWritenDocuments < ActiveRecord::Migration
  def self.up
    create_table :sound_document_writen_documents do |t|
      t.integer :sound_document_id
      t.integer :writen_document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sound_document_writen_documents
  end
end
