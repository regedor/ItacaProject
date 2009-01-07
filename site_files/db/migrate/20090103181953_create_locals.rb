class CreateLocals < ActiveRecord::Migration
  def self.up
    create_table :locals do |t|
      t.string  :name
      t.integer :contry_id
      t.string  :description

      t.timestamps
    end
  end

  def self.down
    drop_table :locals
  end
end
