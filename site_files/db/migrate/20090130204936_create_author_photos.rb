class CreateAuthorPhotos < ActiveRecord::Migration
  def self.up
    create_table :author_photos do |t|
      t.integer :author_id
      t.integer :photo_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :author_photos
  end
end
