class CreateWritenDocumentWritenDocuments < ActiveRecord::Migration
  def self.up
    create_table :writen_document_writen_documents do |t|
      t.integer :writen_document_id
      t.integer :writen_document2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :writen_document_writen_documents
  end
end
