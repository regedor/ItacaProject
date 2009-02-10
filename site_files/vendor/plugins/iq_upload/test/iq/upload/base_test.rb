require File.join(File.dirname(__FILE__), 'unit_test_helper')

# TODO: Should be able to test all of this in isolation i.e. not use
# Factory.uploadified_basic_asset_class and instead use anonymous class to
# include module into.

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# has_upload?
# -----------
class IQ::Upload::Base::HasUploadBoolTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :has_upload?
  end

  def test_return_true_if_filename_set
    asset = Factory.uploadified_basic_asset_class.new
    asset.filename = 'test'
    assert asset.has_upload?, 'Should have upload'
  end

  def test_return_false_if_filename_blank
    assert !Factory.uploadified_basic_asset_class.new.has_upload?, 'Should not have upload'
  end
end

# uploaded_data
# -------------
class IQ::Upload::Base::UploadedDataTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :uploaded_data
  end

  def test_return_nil_when_temp_path_is_nil
    assert_nil Factory.uploadified_basic_asset_class.new.uploaded_data
  end
end

# uploaded_data=
# --------------
class IQ::Upload::Base::UploadedDataSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :uploaded_data=
  end

  def test_should_not_raise_if_file_data_is_nil
    assert_nothing_raised { Factory.uploadified_basic_asset_class.new.uploaded_data = nil }
  end

  def test_should_not_raise_if_file_data_is_zero_sized
    assert_nothing_raised { Factory.uploadified_basic_asset_class.new.uploaded_data = [] }
  end
  
  def test_should_raise_type_error_if_file_data_is_a_non_blank_string
    assert_raises(TypeError) { Factory.uploadified_basic_asset_class.new.uploaded_data = 'invalid file data' }
  end
  
  def test_should_remove_temp_file_when_one_exists
    instance = Factory.uploadified_basic_asset_class.new
    instance.temp_path = 'delete/me'
    FileUtils.expects(:rm_rf).with('delete').once
    instance.uploaded_data = fixture_file_upload('/files/simple.txt', 'text/plain')
  end
  
  def test_should_set_requires_storage_status_to_true
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:requires_storage=).with(true)
    instance.uploaded_data = fixture_file_upload('/files/simple.txt', 'text/plain')
  end
  
  def test_should_set_content_type_correctly
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:content_type=).with('text/plain')
    instance.uploaded_data = fixture_file_upload('/files/simple.txt', 'text/plain')
  end

  def test_should_set_filename_type_correctly
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:filename=).with('simple.txt')
    instance.stubs(:filename).returns('simple.txt')
    instance.uploaded_data = fixture_file_upload('/files/simple.txt', 'text/plain')
  end
  
  def test_should_rewind_file_data_instead_of_closing_when_string_io
    instance = Factory.uploadified_basic_asset_class.new
    file_data = fixture_string_io_upload('/files/simple.txt', 'text/plain')
    file_data.expects(:close).never
    file_data.expects(:rewind).once
    instance.uploaded_data = file_data
  end
  
  def test_should_close_file_date_instead_of_rewinding_when_not_string_io
    instance = Factory.uploadified_basic_asset_class.new
    file_data = fixture_file_upload('/files/simple.txt', 'text/plain')
    file_data.expects(:rewind).never
    file_data.expects(:close).once
    instance.uploaded_data = file_data
  end
  
  def test_should_copy_uploaded_file_to_temp_path
    instance = Factory.uploadified_basic_asset_class.new
    file_data = fixture_file_upload('/files/simple.txt', 'text/plain')
    instance.expects(:copy_uploaded_file_to_temp_path).with(file_data)
    instance.uploaded_data = file_data
  end
end

# already_uploaded_data=
# ----------------------
class IQ::Upload::Base::AlreadyUploadedDataSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :already_uploaded_data=
  end

  def test_should_accept_path_argument_as_string_or_nil
    instance = Factory.uploadified_basic_asset_class.new
    File.stubs(:file?).returns(true)
    assert_nothing_raised(ArgumentError) { instance.already_uploaded_data = '/my/path/' }
    assert_nothing_raised(ArgumentError) { instance.already_uploaded_data = nil }
  end
  
  def test_should_raise_when_path_is_not_string_or_nil
    instance = Factory.uploadified_basic_asset_class.new
    assert_raise(ArgumentError) { instance.already_uploaded_data = :not_string_or_nil }
  end

  def test_should_return_without_setting_temp_path_or_requires_storage_when_path_is_blank
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns(nil)
    instance.expects(:temp_path=).never
    instance.expects(:requires_storage=).never
    instance.already_uploaded_data = nil
    instance.already_uploaded_data = ''
  end

  def test_should_return_without_setting_temp_path_or_requires_storage_when_temp_path_is_already_set
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns('/not/blank')
    instance.expects(:temp_path=).never
    instance.expects(:requires_storage=).never
    instance.already_uploaded_data = 'path/to/../file.txt'
  end

  def test_should_raise_for_security_reasons_when_path_resolves_outside_of_temp_file_base_dir
    instance = Factory.uploadified_basic_asset_class.new
    assert_raise(IQ::Upload::Exceptions::InvalidUploadTempFileError) do
      instance.already_uploaded_data = '../../hacking/attempt'
    end
  end

  def test_should_raise_when_file_does_not_exist_at_expanded_path
    instance = Factory.uploadified_basic_asset_class.new
    File.stubs(:file?).with(
      File.expand_path File.join(instance.temp_file_base_dir, 'path/to/../no-file.txt')
    ).returns(false)
    assert_raise(IQ::Upload::Exceptions::InvalidUploadTempFileError) do
      instance.already_uploaded_data = 'path/to/../no-file.txt'
    end
  end

  def test_should_set_temp_path_to_expanded_path_from_temp_file_base_dir_when_temp_path_blank
    instance = Factory.uploadified_basic_asset_class.new
    expanded_path = File.expand_path(File.join(instance.temp_file_base_dir, 'path/to/../file.txt'))
    File.stubs(:file?).with(expanded_path).returns(true)
    instance.expects(:temp_path=).with(expanded_path)
    instance.already_uploaded_data = 'path/to/../file.txt'
  end

  def test_should_set_requires_storage_to_true_when_temp_path_blank
    instance = Factory.uploadified_basic_asset_class.new
    expanded_path = File.expand_path(File.join(instance.temp_file_base_dir, 'path/to/../file.txt'))
    File.stubs(:file?).with(expanded_path).returns(true)
    instance.expects(:requires_storage=).with(true)
    instance.already_uploaded_data = 'path/to/../file.txt'
  end
  
  def test_should_set_filename_from_basename_of_path_argument
    instance = Factory.uploadified_basic_asset_class.new
    expanded_path = File.expand_path(File.join(instance.temp_file_base_dir, 'path/to/../file.txt'))
    File.stubs(:file?).with(expanded_path).returns(true)
    instance.expects(:filename=).with('file.txt')
    instance.already_uploaded_data = 'path/to/../file.txt'
  end
end

# temp_data
# ---------
class IQ::Upload::Base::TempDataTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :temp_data
  end

  def test_should_return_temp_file_contents
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns('/my/path')
    File.stubs(:new).with('/my/path', 'rb').returns(stub_everything(:read => 'fooey'))
    assert_equal 'fooey', instance.temp_data
  end

  def test_should_ensure_file_is_closed_after_reading
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns('/my/path')
    mock_file_object = stub_everything
    mock_file_object.expects(:close)
    File.stubs(:new).with('/my/path', 'rb').returns(mock_file_object)
    instance.temp_data
  end
end

# filename=
# ---------
class IQ::Upload::Base::FilenameSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :filename=
  end

  def test_should_write_attribute
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, 'my-file.txt')
    instance.filename = 'my-file.txt'
  end

  def test_should_not_affect_setting_to_nil
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, nil)
    instance.filename = nil
  end

  def test_should_strip_string_before_writing_attribute
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, 'my-file.txt')
    instance.filename = '   my-file.txt   '
  end

  def test_should_remove_anything_up_to_and_including_slashes_or_backslashes_before_writing_attribute
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, 'my-file.txt')
    instance.filename = 'this\\is/my-file.txt'
  end
  
  def test_should_replace_anything_other_than_alpha_numerics_dots_or_dashes_with_underscores_before_writing_attribute
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, 'm_y_-f_i_le-.txt')
    instance.filename = 'm y!-f*i_le-.txt'
  end
  
  def test_should_prefix_with_underscore_when_name_starts_with_dot_before_writing_attribute
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:write_attribute).with(:filename, '_.my-sneaky-file.txt')
    instance.filename = '.my-sneaky-file.txt'
  end
end

# relative_dir
# ------------
class IQ::Upload::Base::UploadDirTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :relative_dir
  end

  def test_shoule_return_asset_dir_concatinated_with_instance_dir
    klass = Factory.uploadified_basic_asset_class
    instance = klass.new
    instance.stubs(:instance_dir).returns('bar')
    instance.stubs(:asset_dir).returns('foo')
    assert_equal 'foo/bar', instance.relative_dir
  end
end

# instance_dir
# ------------
class IQ::Upload::Base::UploadDirIdTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :instance_dir
  end

  def test_should_return_stringified_instance_id
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:id).returns(123456)
    assert_equal '0012/3456', instance.instance_dir
  end
end

# storage_path
# ------------
class IQ::Upload::Base::UploadPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :storage_path
  end

  def test_should_return_relative_dir_concatenated_with_filename
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:relative_dir).returns('foo')
    instance.stubs(:filename).returns('bar.txt')
    assert_equal 'foo/bar.txt', instance.storage_path
  end
end

# relative_path
# -------------
class IQ::Upload::Base::RelativePathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :relative_path
  end

  def test_should_return_relative_dir_concatenated_with_filename_relative_to_storage_adapter_relative_base
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:storage_path).returns('public/foo/bar.txt')
    storage_mock = mock()
    storage_mock.expects(:relative_path).with('public/foo/bar.txt').returns('foo/bar.txt')
    instance.stubs(:storage_adapter).returns(storage_mock)
    assert_equal '/foo/bar.txt', instance.relative_path
  end
end

# filename_extension
# ------------------
class IQ::Upload::Base::FilenameExtensionTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :filename_extension
  end

  def test_should_return_everything_after_filenames_last_dot
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:filename).returns('my-file.txt')
    assert_equal 'txt', instance.filename_extension
  end

  def test_should_return_nil_when_filename_has_no_extension
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:filename).returns('my-file')
    assert_nil instance.filename_extension
  end

  def test_should_return_nil_when_filename_is_nil
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:filename).returns(nil)
    assert_nil instance.filename_extension
  end
end

# store_upload
# ------------
class IQ::Upload::Base::ProcessUploadTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :store_upload
  end

  def test_should_persist_to_storage_when_temp_path_set
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns('temp/file.txt')
    instance.stubs(:storage_path).returns('storage/file.txt')
    storage_adapter = mock('Storage Adapter')
    storage_adapter.expects(:store).with('temp/file.txt', 'storage/file.txt')
    instance.stubs(:storage_adapter).returns(storage_adapter)
    instance.store_upload
  end

  def test_should_not_persist_to_storage_when_temp_path_nil
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns(nil)
    instance.expects(:storage_adapter).never
    instance.store_upload
  end
end

# remove_from_storage
# -------------------
class IQ::Upload::Base::RemoveFromStorageTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :remove_from_storage
  end

  def test_should_call_erase_on_storage_adapter_with_correct_arguments
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:storage_path).returns('/my/upload/path')
    expectation = mock()
    expectation.expects(:erase).with('/my/upload/path')
    instance.stubs(:storage_adapter).returns(expectation)
    instance.remove_from_storage
  end
end

# copy_uploaded_file_to_temp_path
# -------------------------------
class IQ::Upload::Base::CopyUploadedFileToTempPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :copy_uploaded_file_to_temp_path
  end

  def test_should_accept_one_argument
    assert_nothing_raised(ArgumentError) do
      instance = Factory.uploadified_basic_asset_class.new
      instance.stubs(:filename).returns('my_file.txt')
      FileUtils.stubs(:copy_file)
      File.stubs(:size)
      instance.copy_uploaded_file_to_temp_path(fixture_file_upload('/files/simple.txt', 'text/plain'))
    end
  end
  
  def test_should_set_random_temp_path
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:set_random_temp_path).with()
    FileUtils.stubs(:copy_file)
    File.stubs(:size)
    instance.copy_uploaded_file_to_temp_path(fixture_file_upload('/files/simple.txt', 'text/plain'))
  end

  def test_should_copy_file_to_newly_set_temp_path_when_file_object_and_has_path_to_valid_file
    instance = Factory.uploadified_basic_asset_class.new
    def instance.set_random_temp_path
      self.temp_path = 'random_temp_path'
    end
    file_data = fixture_file_upload('/files/simple.txt', 'text/plain')
    FileUtils.expects(:copy_file).with(file_data.path, 'random_temp_path')
    File.stubs(:size)
    instance.copy_uploaded_file_to_temp_path(file_data)
  end
  
  def test_should_copy_file_to_newly_set_temp_path_when_file_object_has_read_method_and_no_valid_path_to_file
    instance = Factory.uploadified_basic_asset_class.new
    def instance.set_random_temp_path
      asset_temp_dir = File.join(temp_file_base_dir, 'random_temp_path')
      FileUtils.mkdir_p(asset_temp_dir)
      self.temp_path = File.join(asset_temp_dir, 'simple.txt')
    end
    file_data = fixture_string_io_upload('/files/simple.txt', 'text/plain')
    instance.copy_uploaded_file_to_temp_path(file_data)
    assert_equal(
      IO.read(File.join(File.dirname(__FILE__), '/files/simple.txt')),
      IO.read(File.join(instance.temp_file_base_dir, 'random_temp_path', 'simple.txt'))
    )
  end
  
  def test_should_raise_argument_error_if_file_object_has_no_valid_path_to_file_and_cant_be_read
    instance = Factory.uploadified_basic_asset_class.new
    instance.expects(:set_random_temp_path).with().times(2)
    assert_raises(ArgumentError) { instance.copy_uploaded_file_to_temp_path(nil) }
    assert_raises(ArgumentError) { instance.copy_uploaded_file_to_temp_path('fooey') }
  end
  
  def test_should_set_file_size_when_upload_copied_to_temp_file
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:filename).returns('simple.txt')
    instance.copy_uploaded_file_to_temp_path(fixture_file_upload('/files/simple.txt', 'text/plain'))
    assert_equal(
      File.size(File.join(File.dirname(__FILE__), '/files/simple.txt')),
      instance.file_size
    )
  end
end

# set_random_temp_path
# --------------------
class IQ::Upload::Base::SetRandomTempPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :set_random_temp_path
  end
  
  def test_should_should_make_randomly_named_directory_in_temp_file_base_dir
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:random_filename).returns('fooey')
    instance.stubs(:filename).returns('my_file.txt')
    mock_time_now = mock(:to_i => 1234, :usec => 567)
    Time.expects(:now).returns(mock_time_now)
    Process.expects(:pid).returns(89)
    FileUtils.expects(:mkdir_p).with(File.join(instance.temp_file_base_dir, '1234.567.89'))
    instance.set_random_temp_path
  end
  
  def test_should_set_temp_path_to_randomly_named_directory_with_filename_appended_and_return
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:random_filename).returns('fooey')
    instance.stubs(:filename).returns('my_file.txt')
    mock_time_now = mock(:to_i => 1234, :usec => 567)
    Time.expects(:now).returns(mock_time_now)
    Process.expects(:pid).returns(89)
    assert_equal(
      File.join(instance.temp_file_base_dir, '1234.567.89', 'my_file.txt'), 
      instance.set_random_temp_path
    )
  end
end

# already_uploaded_data
# ---------------------
class IQ::Upload::Base::AlreadyUploadedDataTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :already_uploaded_data
  end

  def test_should_return_nil_when_temp_path_nil
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_path).returns(nil)
    assert_nil instance.already_uploaded_data
  end

  def test_should_return_expanded_path_to_temp_file_relative_to_base_temp_file_dir_when_temp_path_available
    instance = Factory.uploadified_basic_asset_class.new
    instance.stubs(:temp_file_base_dir).returns('/full/path/to')
    instance.stubs(:temp_path).returns('/full/../full/path/to/tmp/../tmp/file.txt')
    assert_equal '/tmp/file.txt', instance.already_uploaded_data
  end
end

# requires_storage?
# -----------------
class IQ::Upload::Base::JustUploadedBoolTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :requires_storage?
  end

  def test_should_return_false_by_default
    assert_equal false, Factory.uploadified_basic_asset_class.new.requires_storage?
  end
  
  def test_should_return_true_when_instance_variable_value_is_true
    instance = Factory.uploadified_basic_asset_class.new
    instance.instance_variable_set '@requires_storage', true
    assert_equal true, instance.requires_storage?
  end
end

# requires_storage=
# -----------------
class IQ::Upload::Base::JustUploadedSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :requires_storage=
  end

  def test_should_set_value_of_requires_storage_instance_variable
    instance = Factory.uploadified_basic_asset_class.new
    instance.requires_storage = true
    assert_equal true, instance.instance_variable_get('@requires_storage')
  end
end

# asset_dir
# ---------
class IQ::Upload::Base::UploadDirectoryNameTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :asset_dir
  end

  def test_should_return_underscored_plural_of_class_name_prefixed_with_assets_by_default
    assert_equal(
      File.join(IQ::Upload::Config.default_storage_dir, 'basic_assets'), 
      Factory.uploadified_basic_asset_class.new.asset_dir
    )
  end

  def test_should_return_underscored_plural_of_base_class_name_for_sti_prefixed_with_assets_by_default
    klass = Class.new(Factory.basic_asset_class)
    klass.stubs(:name).returns('BasicAsset')
    klass.uploadify
    assert_equal File.join(IQ::Upload::Config.default_storage_dir, 'basic_assets'), klass.new.asset_dir
  end  

  def test_should_return_underscored_plural_of_class_name_prefixed_with_uploadify_dir_option
    assert_equal 'an_asset_dir', Factory.uploadified_basic_asset_class(:dir => 'an_asset_dir').new.asset_dir
  end

  def test_should_return_underscored_plural_of_base_class_name_for_sti_prefixed_with_uploadify_dir_option
    klass = Class.new(Factory.basic_asset_class)
    klass.stubs(:name).returns('BasicAsset')
    klass.uploadify :dir => 'my_asset_dir'
    assert_equal 'my_asset_dir', klass.new.asset_dir
  end  
end

# temp_file_base_dir
# ------------------
class IQ::Upload::Base::TempFileBaseDirectoryTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.uploadified_basic_asset_class.new, :temp_file_base_dir
  end

  def test_should_return_concatinated_tempfile_path_and_asset_dir
    klass = Factory.uploadified_basic_asset_class
    assert_equal(
      File.join(IQ::Upload::Config.tempfile_path, klass.new.asset_dir), klass.new.temp_file_base_dir
    )
  end
end