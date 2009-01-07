class CreateMovieWritenDocuments < ActiveRecord::Migration
  def self.up
    create_table :movie_writen_documents do |t|
      t.integer :movie_id
      t.integer :writen_document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_writen_documents
  end
end
