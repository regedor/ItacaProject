class CreatePhotoPhotos < ActiveRecord::Migration
  def self.up
    create_table :photo_photos do |t|
      t.integer :photo_id
      t.integer :photo2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_photos
  end
end
