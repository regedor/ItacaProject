class CreateContries < ActiveRecord::Migration
  def self.up
    create_table :contries do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :contries
  end
end
