require File.join(File.dirname(__FILE__), 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# file_size
# ---------
class IQ::Upload::MetaDataAccessors::ContentTypeTest < Test::Unit::TestCase
  def test_should_respond_regardless_of_column_existence
    assert_respond_to Factory.uploadified_basic_asset_class.new, :file_size
    assert_respond_to Factory.uploadified_meta_data_asset_class.new, :file_size
  end

  def test_should_return_nil_by_default_regardless_of_column_existence
    assert_nil Factory.uploadified_basic_asset_class.new.file_size
    assert_nil Factory.uploadified_meta_data_asset_class.new.file_size
  end
  
  def test_should_return_attribute_when_present
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.write_attribute 'file_size', 321
    assert_equal 321, instance.file_size
  end

  def test_should_return_file_size_instance_variable_when_attribute_not_available
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.instance_variable_set '@file_size', 321
    instance.write_attribute 'file_size', nil
    assert_equal 321, instance.file_size
  end
end

# file_size=
# ----------
class IQ::Upload::MetaDataAccessors::ContentTypeSetterTest < Test::Unit::TestCase
  def test_should_respond_regardless_of_column_existence
    assert_respond_to Factory.uploadified_basic_asset_class.new, :file_size=
      assert_respond_to Factory.uploadified_meta_data_asset_class.new, :file_size=
  end

  def test_should_set_attribute_when_column_available
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.file_size = 321
    assert_equal 321, instance.read_attribute(:file_size)
  end

  def test_should_retain_value_in_instance_variable_when_column_unavailable
    instance = Factory.uploadified_basic_asset_class.new
    instance.file_size = 321
    assert_equal 321, instance.instance_variable_get('@file_size')
  end
  
  def test_should_should_convert_value_to_integer
    instance = Factory.uploadified_basic_asset_class.new
    instance.file_size = '321 Testy'
    assert_equal 321, instance.instance_variable_get('@file_size')
  end
end

# content_type
# ------------
class IQ::Upload::MetaDataAccessors::ContentTypeTest < Test::Unit::TestCase
  def test_should_respond_regardless_of_column_existence
    assert_respond_to Factory.uploadified_basic_asset_class.new, :content_type
    assert_respond_to Factory.uploadified_meta_data_asset_class.new, :content_type
  end

  def test_should_return_nil_by_default_regardless_of_column_existence
    assert_nil Factory.uploadified_basic_asset_class.new.content_type
    assert_nil Factory.uploadified_meta_data_asset_class.new.content_type
  end
  
  def test_should_return_attribute_when_present
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.write_attribute 'content_type', 'foo/bar'
    assert_equal 'foo/bar', instance.content_type
  end

  def test_should_return_content_type_instance_variable_when_attribute_not_available
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.instance_variable_set '@content_type', 'foo/bar'
    instance.write_attribute 'content_type', nil
    assert_equal 'foo/bar', instance.content_type
  end
end

# content_type=
# -------------
class IQ::Upload::MetaDataAccessors::ContentTypeSetterTest < Test::Unit::TestCase
  def test_should_respond_regardless_of_column_existence
    assert_respond_to Factory.uploadified_basic_asset_class.new, :content_type=
      assert_respond_to Factory.uploadified_meta_data_asset_class.new, :content_type=
  end

  def test_should_set_attribute_when_column_available
    instance = Factory.uploadified_meta_data_asset_class.new
    instance.content_type = 'foo/bar'
    assert_equal 'foo/bar', instance.read_attribute(:content_type)
  end

  def test_should_retain_value_in_instance_variable_when_column_unavailable
    instance = Factory.uploadified_basic_asset_class.new
    instance.content_type = 'foo/bar'
    assert_equal 'foo/bar', instance.instance_variable_get('@content_type')
  end
end

