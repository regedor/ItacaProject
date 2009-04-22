class AddExtraAuthors < ActiveRecord::Migration
  def self.up
    add_column :movies, :author_2_id, :integer
    add_column :movies, :author_3_id, :integer
    add_column :movies, :author_4_id, :integer
    add_column :movies, :author_5_id, :integer
    add_column :sound_documents, :author_2_id, :integer
    add_column :sound_documents, :author_3_id, :integer
    add_column :sound_documents, :author_4_id, :integer
    add_column :sound_documents, :author_5_id, :integer
    add_column :writen_documents, :author_2_id, :integer
    add_column :writen_documents, :author_3_id, :integer
    add_column :writen_documents, :author_4_id, :integer
    add_column :writen_documents, :author_5_id, :integer
    add_column :photos, :author_2_id, :integer
    add_column :photos, :author_3_id, :integer
    add_column :photos, :author_4_id, :integer
    add_column :photos, :author_5_id, :integer
  end

  def self.down
    remove_column :movies, :author_2_id
    remove_column :movies, :author_3_id
    remove_column :movies, :author_4_id
    remove_column :movies, :author_5_id
    remove_column :sound_documents, :author_2_id
    remove_column :sound_documents, :author_3_id
    remove_column :sound_documents, :author_4_id
    remove_column :sound_documents, :author_5_id
    remove_column :writen_documents, :author_2_id
    remove_column :writen_documents, :author_3_id
    remove_column :writen_documents, :author_4_id
    remove_column :writen_documents, :author_5_id
    remove_column :photos, :author_2_id
    remove_column :photos, :author_3_id
    remove_column :photos, :author_4_id
    remove_column :photos, :author_5_id
  end
end
