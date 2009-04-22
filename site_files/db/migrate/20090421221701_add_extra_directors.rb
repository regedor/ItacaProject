class AddExtraDirectors < ActiveRecord::Migration
  def self.up
    add_column :movies, :director_2_id, :integer
    add_column :movies, :director_3_id, :integer
    add_column :movies, :director_4_id, :integer
    add_column :movies, :director_5_id, :integer
    add_column :sound_documents, :director_2_id, :integer
    add_column :sound_documents, :director_3_id, :integer
    add_column :sound_documents, :director_4_id, :integer
    add_column :sound_documents, :director_5_id, :integer
  end
  
  def self.down
    remove_column :movies, :director_2_id
    remove_column :movies, :director_3_id
    remove_column :movies, :director_4_id
    remove_column :movies, :director_5_id
    remove_column :sound_documents, :director_2_id
    remove_column :sound_documents, :director_3_id
    remove_column :sound_documents, :director_4_id
    remove_column :sound_documents, :director_5_id
  end
end
