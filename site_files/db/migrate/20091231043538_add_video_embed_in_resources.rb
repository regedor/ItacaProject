class AddVideoEmbedInResources < ActiveRecord::Migration
  def self.up
    add_column :movies, :video_embed, :text
    add_column :sound_documents, :video_embed, :text
  end
  
  def self.down
    remove_column :movies, :video_embed
    remove_column :sound_documents, :video_embed
  end
end
