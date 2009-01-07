class CreateWritenDocumentLocals < ActiveRecord::Migration
  def self.up
    create_table :writen_document_locals do |t|
      t.integer :writen_document_id
      t.integer :local_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :writen_document_locals
  end
end
