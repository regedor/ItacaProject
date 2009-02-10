# Accessors for :file_size and :content_type - when the columns are not present the values will be
# stored in instance variables to allow validation etc.
module IQ::Upload::MetaDataAccessors
  def file_size=(value)
    self.class.column_names.include?('file_size') ? write_attribute(:file_size, value) : @file_size = value.to_i
  end

  def file_size
    read_attribute(:file_size) || @file_size
  end

  def content_type=(type)
    self.class.column_names.include?('content_type') ? write_attribute(:content_type, type) : @content_type = type
  end
  
  def content_type
    read_attribute(:content_type) || @content_type
  end
end