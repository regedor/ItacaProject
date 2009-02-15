ActiveRecord::Schema.define(:version => 1) do
  create_table :basic_assets, :force => true do |t|
    t.column :filename, :string, :limit => 255
  end
  
  create_table :meta_data_assets, :force => true do |t|
    t.column :filename,     :string,  :limit => 255
    t.column :content_type, :string,  :limit => 255
    t.column :file_size,    :integer
  end
  
#  create_table :assets, :force => true do |t|
#    t.column :base_version_id,       :integer
#    t.column :version_name,    :string
#    t.column :filename,        :string, :limit => 255
#    t.column :content_type,    :string, :limit => 255
#    t.column :file_size,            :integer
#    t.column :width,           :integer
#    t.column :height,          :integer
#    t.column :aspect_ratio,    :float
#    t.column :type,            :string
#    t.column :crop_options,    :string
#    t.column :other_column,    :string
#  end
#
#  create_table :mini_magick_assets, :force => true do |t|
#    t.column :base_version_id,       :integer
#    t.column :version_name,    :string
#    t.column :filename,        :string, :limit => 255
#    t.column :content_type,    :string, :limit => 255
#    t.column :file_size,            :integer
#    t.column :width,           :integer
#    t.column :height,          :integer
#    t.column :aspect_ratio,    :float
#  end
#
#  create_table :db_backed_assets, :force => true do |t|
#    t.column :processor_db_file_id,      :integer
#    t.column :filename,        :string, :limit => 255
#    t.column :content_type,    :string, :limit => 255
#  end
#
#  create_table :background_rb_processed_assets, :force => true do |t|
#    t.column :base_version_id,       :integer
#    t.column :version_name,    :string
#    t.column :filename,        :string, :limit => 255
#    t.column :content_type,    :string, :limit => 255
#    t.column :file_size,            :integer
#    t.column :width,           :integer
#    t.column :height,          :integer
#    t.column :backgroundrb_job_key, :string
#  end
#  
#  create_table :processor_db_files, :force => true do |t|
#    t.column :data, :binary
#  end
end