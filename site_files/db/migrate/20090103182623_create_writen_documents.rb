class CreateWritenDocuments < ActiveRecord::Migration
  def self.up
    create_table :writen_documents do |t|
      t.string :title
      t.integer :document_type_id
      t.text :synopsis
      t.integer :author_id
      t.string :editor
      t.integer :production_year
      t.integer :local_id
      t.text :comments
      t.text :production_context
      t.string :distributor
      t.string :format
      t.integer :category_id
      t.integer :category_id1
      t.integer :category_id2
      t.integer :category_id3
      t.integer :category_id4
      t.boolean :free
      t.string :rights

      t.timestamps
    end
  end

  def self.down
    drop_table :writen_documents
  end
end
