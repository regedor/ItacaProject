class CreateDirectors < ActiveRecord::Migration
  def self.up
    create_table :directors do |t|
      t.string :name
      t.text   :biography
      t.string :first_work


      t.integer :user_id
      t.integer :status, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :directors
  end
end
