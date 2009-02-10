module IQ::Upload::Base
  # Name of directory/path under which uploaded files will be available. (based on class name and storage directory)
  #   MyAsset < ActiveRecord::Base
  #   MyAsset.asset_dir => 'public/assets/my_assets'
  #
  #   MyImage < MyAsset
  #   MyImage.asset_dir => 'public/assets/my_images'
  def asset_dir
    self.class.read_inheritable_attribute(:uploadify_options)[:dir] || File.join(
      IQ::Upload::Config.default_storage_dir, self.class.name.underscore.pluralize
    )
  end

  # Directory where files will be temporarily stored during uploading
  def temp_file_base_dir
    File.join(IQ::Upload::Config.tempfile_path, asset_dir)
  end
 
  # Returns true if a file has successfully been attached to this record.
  def has_upload?
    !self.filename.blank?
  end

  # Returns true if the model has #uploaded_data= assigned.
  def requires_storage?
    !!@requires_storage
  end
  
  # Sets requires_storage? status
  def requires_storage=(value)
    @requires_storage = value
  end

  # Returns nil - for use in a form.
  def uploaded_data
    nil
  end

  # Assign file data to this to upload data.
  #
  #   <% form_for :my_asset, :html => { :multipart => true } do |f| -%>
  #     <%= f.file_field :uploaded_data %>
  #     <%= submit_tag 'Upload' %>
  #   <% end -%>
  #
  # or better yet
  #
  #   <% form_for :my_asset, :html => { :multipart => true } do |f| -%>
  #     <%= f.uploadify_file_field %>
  #     <%= submit_tag 'Upload' %>
  #   <% end -%>
  #
  #   @my_asset = MyAsset.create! params[:my_asset]
  def uploaded_data=(file_data)
    return if file_data.nil? || file_data.size == 0
    raise TypeError, 'Expected file, got String. Ensure form enctype of "multipart/form-data"' if file_data.is_a? String
    
    # Clear existing temp file
    FileUtils.rm_rf File.dirname(self.temp_path) unless self.temp_path.nil?
    
    self.requires_storage = true
    self.content_type     = (file_data.content_type || '').strip
    self.filename         = file_data.original_filename

    file_data.is_a?(StringIO) ? file_data.rewind : file_data.close
    copy_uploaded_file_to_temp_path(file_data)
  end

  # Copies uploaded file to a temp file within IQ::Upload::Config.tempfile_path
  def copy_uploaded_file_to_temp_path(file)
    set_random_temp_path
    if file.respond_to?(:path) && file.path && File.exists?(file.path)
      FileUtils.copy_file(file.path, temp_path)
    elsif file.respond_to?(:read)
      File.open(temp_path, 'wb') { |f| f.write(file.read) }
    else
      raise ArgumentError, "Do not know how to handle #{file.inspect}"
    end
    self.file_size = File.size(temp_path)
  end

  # Sets temp_path to a new random name of the form /tmp/uploads/#{table_name}/#{filename}
  # 
  # Note: This doesn't use an actual TempFile as it is used between form refreshes therefore these files may need
  # cleaning up on a cron schedule.
  def set_random_temp_path
    now = Time.now
    asset_temp_dir = File.join(temp_file_base_dir, "#{now.to_i}.#{now.usec}.#{Process.pid}")
    FileUtils.mkdir_p(asset_temp_dir)
    self.temp_path = File.join(asset_temp_dir, self.filename)
  end

  # Path to #temp_path relative to #temp_file_base_dir - used to keep uploaded files files across form redisplays
  def already_uploaded_data
    temp_path && File.expand_path(temp_path).sub(/^#{Regexp.escape(File.expand_path(temp_file_base_dir))}/, '')
  end

  # Used to keep uploaded files across form redisplays if assigned with a valid path (of form #already_uploaded_data).
  # Will use the corresponding file previously uploaded as if it were passed to #uploaded_data=
  def already_uploaded_data=(path)
    raise ArgumentError, 'Path must be supplied as String or Nil' unless path.is_a?(String) || path.nil?
    return if !self.temp_path.blank? || path.blank?
    tempfile_path = File.expand_path(File.join(temp_file_base_dir, path))

    # Security check to not let files be written outside of temp_file_base_dir
    unless tempfile_path.starts_with?(File.expand_path(temp_file_base_dir)) && File.file?(tempfile_path)
      raise IQ::Upload::Exceptions::InvalidUploadTempFileError, 'Invalid path to temp file'
    end
    self.requires_storage = true
    self.temp_path = tempfile_path
    self.filename = File.basename(tempfile_path)

    # TODO: Set content type and make form helper set class on span
  end

  # Reads and returns the contents of temp_file
  def temp_data
    file = File.new(temp_path, 'rb')
    file.read ensure file.close
  end

  # Sanitizes filename before writing the attribute
  def filename=(new_name)
    write_attribute :filename, new_name && new_name.strip.sub(/^.*(\\|\/)/, '').gsub(/[^\w\.\-]/, '_').sub(/^\./, '_.')
  end

  # Returns the file extension from #filename. eg. filename of "my_image.jpg" returns 'jpg'
  def filename_extension
    filename && File.extname(filename)[1..-1]
  end
  
  # Returns id attribute as String by default
  def instance_dir
    File.join(("%08d" % id.to_s).scan(/..../))
  end
  
  # Returns path to upload instance directory relative to the upload storage base path
  def relative_dir
    File.join(self.asset_dir, instance_dir)
  end
  
  # Returns relative path to upload from storage relative base path
  def relative_path
    File.join('', storage_adapter.relative_path(storage_path))
  end
 
  # Returns relative path to upload from storage absolute base path
  def storage_path
    File.join(relative_dir, filename)
  end
  
  # Persists the file at temp_path to storage if it exists
  def store_upload
    storage_adapter.store temp_path, storage_path unless temp_path.nil?
  end

  # Removes the uploaded data via storage adapter based on the identifier specific to the current model instance
  def remove_from_storage
    storage_adapter.erase(self.storage_path)
  end
  
  # Returns value of call to self.class.uploadify_storage_adapter Proc
  def storage_adapter
    self.class.uploadify_storage_adapter.call
  end
end
