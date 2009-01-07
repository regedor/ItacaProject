class CreatePrizeLocals < ActiveRecord::Migration
  def self.up
    create_table :prize_locals do |t|
      t.integer :prize_id
      t.integer :local_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :prize_locals
  end
end
