class CreateSoundDocumentPrizes < ActiveRecord::Migration
  def self.up
    create_table :sound_document_prizes do |t|
      t.integer :sound_document_id
      t.integer :prize_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :sound_document_prizes
  end
end
