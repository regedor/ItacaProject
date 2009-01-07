class CreatePhotoLocals < ActiveRecord::Migration
  def self.up
    create_table :photo_locals do |t|
      t.integer :photo_id
      t.integer :local_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_locals
  end
end
