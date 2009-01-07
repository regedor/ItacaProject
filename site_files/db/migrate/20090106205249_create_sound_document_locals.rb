class CreateSoundDocumentLocals < ActiveRecord::Migration
  def self.up
    create_table :sound_document_locals do |t|
      t.integer :sound_document_id
      t.integer :local_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :sound_document_locals
  end
end
