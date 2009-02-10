class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= upload_db_files_table_name %> do |t|
      t.column :data, :binary
    end
  end

  def self.down
    drop_table :<%= upload_db_files_table_name %>
  end
end
