class CreateLocalLocals < ActiveRecord::Migration
  def self.up
    create_table :local_locals do |t|
      t.integer :local_id
      t.integer :local2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :local_locals
  end

end
