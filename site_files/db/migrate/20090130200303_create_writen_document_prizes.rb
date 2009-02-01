class CreateWritenDocumentPrizes < ActiveRecord::Migration
  def self.up
    create_table :writen_document_prizes do |t|
      t.integer :writen_document_id
      t.integer :prize_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :writen_document_prizes
  end
end
