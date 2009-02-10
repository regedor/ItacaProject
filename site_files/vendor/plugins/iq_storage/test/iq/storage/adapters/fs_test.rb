require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Definition
# -----------------------------------------------------------------------------------------------
class IQ::Storage::Adapters::Fs::ClassDefinitionTest < Test::Unit::TestCase
  def test_should_inherit_base_storage_adapter
    assert_equal IQ::Storage::Adapters::Base, IQ::Storage::Adapters::Fs.superclass
  end
end

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# store
# -----
class IQ::Storage::Adapters::Fs::StoreTest < Test::Unit::TestCase
  def test_should_require_two_arguments
    FileUtils.stubs(:mkdir_p)
    FileUtils.stubs(:cp)
    File.stubs(:chmod)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.store }
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.store('only one argument') }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.store('arg1', 'arg2') }
  end
  
  def test_should_require_first_argument_as_string
    FileUtils.stubs(:mkdir_p)
    FileUtils.stubs(:cp)
    File.stubs(:chmod)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.store(:not_a_string, 'string') }
  end

  def test_should_require_second_argument_as_string
    FileUtils.stubs(:mkdir_p)
    FileUtils.stubs(:cp)
    File.stubs(:chmod)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.store('string', :not_a_string) }
  end
  
  def test_should_not_raise_with_valid_arguments
    FileUtils.stubs(:mkdir_p)
    FileUtils.stubs(:cp)
    File.stubs(:chmod)
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.store('string', 'string') }    
  end
  
  def test_should_ensure_directory_is_created_at_absolute_storage_path_dir_with_correct_permissions
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('storage/path/file.txt').returns('/stubbed/path/file.txt')
    FileUtils.expects(:mkdir_p).with('/stubbed/path', :mode => 0755)
    FileUtils.stubs(:cp)
    File.stubs(:chmod)
    instance.store 'from/path/file.txt', 'storage/path/file.txt'
  end
  
  def test_should_ensure_file_is_copied_to_absolute_storage_path
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('storage/path/file.txt').returns('/stubbed/file.txt')
    FileUtils.stubs(:mkdir_p)
    FileUtils.expects(:cp).with('from/path/file.txt', '/stubbed/file.txt')
    File.stubs(:chmod)
    instance.store 'from/path/file.txt', 'storage/path/file.txt'
  end

  def test_should_set_correct_permissions_on_file_at_absolute_storage_path
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('storage/path/file.txt').returns('/stubbed/file.txt')
    FileUtils.stubs(:mkdir_p)
    FileUtils.stubs(:cp)
    File.expects(:chmod).with(0644, '/stubbed/file.txt')
    instance.store 'from/path/file.txt', 'storage/path/file.txt'
  end
end

# fetch
# -----
class IQ::Storage::Adapters::Fs::FetchTest < Test::Unit::TestCase
  def test_should_require_two_arguments
    FileUtils.stubs(:cp)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.fetch }
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.fetch('only one argument') }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.fetch('arg1', 'arg2') }
  end
  
  def test_should_require_first_argument_as_string
    FileUtils.stubs(:cp)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.fetch(:not_a_string, 'string') }
  end

  def test_should_require_second_argument_as_string
    FileUtils.stubs(:cp)
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.fetch('string', :not_a_string) }
  end
  
  def test_should_not_raise_with_valid_arguments
    FileUtils.stubs(:cp)
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.fetch('string', 'string') }    
  end
  
  def test_should_copy_file_from_absolute_storage_path_to_local_path
    FileUtils.expects(:cp).with('absolute', 'local')
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('storage').returns('absolute')
    instance.fetch('storage', 'local')
  end
end

# erase
# -----
class IQ::Storage::Adapters::Fs::EraseTest < Test::Unit::TestCase
  def test_should_respond
    FileUtils.stubs(:rm)
    Dir.stubs(:empty?)
    FileUtils.stubs(:rm_rf)
    assert_respond_to Factory.new_valid_base_adapter, :erase
  end

  def test_should_require_one_argument
    FileUtils.stubs(:rm)
    Dir.stubs(:empty?)
    FileUtils.stubs(:rm_rf)
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.erase }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.erase('instance') }
  end
  
  def test_should_require_argument_as_string
    FileUtils.stubs(:rm)
    Dir.stubs(:empty?)
    FileUtils.stubs(:rm_rf)
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.erase(:not_a_string) }
  end
    
  def test_should_not_raise_with_valid_arguments
    FileUtils.stubs(:rm)
    Dir.stubs(:empty?)
    FileUtils.stubs(:rm_rf)
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.erase('string') }    
  end
  
  def test_should_delete_file_at_absolute_storage_path
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('foo').returns('bar/file.txt')
    File.stubs(:exists?).with('bar/file.txt').returns(true)
    File.stubs(:exists?).with('bar')
    FileUtils.expects(:rm).with('bar/file.txt')
    instance.stubs(:directory_empty?)
    FileUtils.stubs(:rm_rf)
    instance.erase 'foo'
  end

  def test_should_remove_directories_recursively_while_empty
    instance = Factory.new_valid_fs_adapter(:absolute_base => '/foo')
    instance.stubs(:absolute_path).with('bar/baz/bill/file.txt').returns('/foo/bar/baz/bill/file.txt')
    FileUtils.stubs(:rm)
    instance.stubs(:directory_empty?).with('/foo/bar/baz/bill').returns(true)
    instance.stubs(:directory_empty?).with('/foo/bar/baz').returns(true)
    instance.stubs(:directory_empty?).with('/foo/bar').returns(false)
    File.stubs(:exists?).returns(true)
    FileUtils.expects(:rm_rf).with('/foo/bar/baz/bill')
    FileUtils.expects(:rm_rf).with('/foo/bar/baz')
    instance.erase 'bar/baz/bill/file.txt'
  end
  
  def test_should_not_remove_directories_below_or_including_absolute_base
    instance = Factory.new_valid_fs_adapter(:absolute_base => '/foo')
    instance.stubs(:absolute_path).with('bar/file.txt').returns('/foo/bar/file.txt')
    FileUtils.stubs(:rm)
    instance.stubs(:directory_empty?).returns(true)
    File.stubs(:exists?).returns(true)
    FileUtils.expects(:rm_rf).with('/foo/bar')
    #FileUtils.expects(:rm_rf).with('/foo').never
    instance.erase 'bar/file.txt'
  end
    
  def test_should_not_remove_directories_below_or_including_current_directory
    instance = Factory.new_valid_fs_adapter
    cwd = File.expand_path('.')
    instance.stubs(:absolute_path).with('bar/file.txt').returns(File.join(cwd, 'bar', 'file.txt'))
    FileUtils.stubs(:rm)
    instance.stubs(:directory_empty?).returns(true)
    File.stubs(:exists?).returns(true)
    FileUtils.expects(:rm_rf).with(File.join(cwd, 'bar'))
    #FileUtils.expects(:rm_rf).with(cwd).never
    instance.erase 'bar/file.txt'
  end

  def test_should_leave_directory_alone_when_not_empty
    instance = Factory.new_valid_fs_adapter
    instance.stubs(:absolute_path).with('foo').returns('bar/file.txt')
    FileUtils.stubs(:rm)
    Dir.stubs(:empty?).returns(false)
    instance.stubs(:directory_empty?).returns(false)
    FileUtils.expects(:rm_rf).never
    instance.erase 'foo'
  end
end

# absolute_path
# -------------
class IQ::Storage::Adapters::Fs::AbsolutePathTest < Test::Unit::TestCase
  def test_should_require_one_argument
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.absolute_path }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.absolute_path('the/path') }
  end

  def test_should_require_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.absolute_path(:not_a_string) }
  end
  
  def test_should_raise_when_storage_path_falls_outside_of_absolute_base
    assert_raise(IQ::Storage::Adapters::Fs::Exceptions::OutsideBaseDirectoryError) do
      Factory.new_valid_fs_adapter(:absolute_base => '/base/dir').absolute_path(
        'i/../../../am/below/base/copied-file.txt'
      )
    end
  end

  def test_should_raise_if_given_absolute_path_outside_of_absolute_base
    assert_raise(IQ::Storage::Adapters::Fs::Exceptions::OutsideBaseDirectoryError) do
      Factory.new_valid_fs_adapter(:absolute_base => '/base/dir').absolute_path(
        '/i/am/outside/of/base/copied-file.txt'
      )
    end
  end

  def test_should_return_expanded_path_relative_to_current_directory_when_absolute_base_is_nil
    assert_equal(
      File.expand_path('i/am/a/directory/file.txt'), 
      Factory.new_valid_fs_adapter.absolute_path('i/am/a/directory/file.txt')
    )
  end

  def test_should_return_expanded_path_of_absolute_base_concatinated_with_storage_path_when_absolute_base_option_set
    assert_equal(
      File.expand_path('/base/dir/i/am/a/directory/file.txt'), 
      Factory.new_valid_fs_adapter(:absolute_base => '/base/dir/../dir').absolute_path('i/am/a/directory/file.txt')
    )
  end
end

# relative_path
# -------------
class IQ::Storage::Adapters::Fs::RelativePathTest < Test::Unit::TestCase
  def test_should_require_one_argument
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.relative_path }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_fs_adapter.relative_path('the/path') }
  end

  def test_should_require_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_fs_adapter.relative_path(:not_a_string) }
  end
  
  def test_should_raise_when_storage_path_resolves_outside_of_relative_base
    assert_raise(IQ::Storage::Adapters::Fs::Exceptions::OutsideBaseDirectoryError) do
      Factory.new_valid_fs_adapter(:relative_base => '/base/dir').relative_path(
        'i/../../../am/below/base/copied-file.txt'
      )
    end
  end

  def test_should_return_path_relative_to_absolute_base_when_relative_base_is_nil
    assert_equal(
      'a/directory/file.txt', 
      Factory.new_valid_fs_adapter(:absolute_base => 'i/am').relative_path('a/directory/file.txt')
    )
  end

  def test_should_return_path_relative_to_current_directory_when_relative_base_and_absolute_base_are_nil
    assert_equal(
      'i/am/a/directory/file.txt', 
      Factory.new_valid_fs_adapter.relative_path('i/am/a/directory/file.txt')
    )
  end

  def test_should_return_storage_path_relative_to_relative_base_when_relative_base_option_set
    assert_equal(
      'files/i/am/a/directory/file.txt', 
      Factory.new_valid_fs_adapter(
        :absolute_base => '/base/dir/../dir/files', :relative_base => '/base/dir/../dir'
      ).relative_path('i/am/a/directory/file.txt')
    )
  end
  
  def test_should_not_raise_when_storage_path_with_absolute_path_resolves_inside_relative_path
    assert_equal(
      'files/copied-file.txt',
      Factory.new_valid_fs_adapter(:absolute_base => '/base', :relative_base => '/base/dir').relative_path(
        'dir/files/copied-file.txt'
      )
    )    
  end
end

# default_options
# ---------------
class IQ::Storage::Adapters::Fs::DefaultOptionsTest < Test::Unit::TestCase
  def test_should_return_nil_for_absolute_base_option
    assert_nil Factory.new_valid_fs_adapter.default_options[:absolute_base]
  end
  
  def test_should_return_nil_for_relative_base_option
    assert_nil Factory.new_valid_fs_adapter.default_options[:relative_base]
  end
end

# valid_options
# -------------
class IQ::Storage::Adapters::Fs::ValidOptionsTest < Test::Unit::TestCase
  def test_should_include_absolute_base
    assert Factory.new_valid_fs_adapter.valid_options.include?(:absolute_base), ':absolute_base should be valid option'
  end
  
  def test_should_include_absolute_base
    assert Factory.new_valid_fs_adapter.valid_options.include?(:relative_base), ':relative_base should be valid option'
  end
  
  def test_should_include_tempfile_base
    assert Factory.new_valid_fs_adapter.valid_options.include?(:tempfile_base), ':tempfile_base should be valid option'
  end
  
  def test_should_lazy_initialize_output
    instance = Factory.new_valid_fs_adapter
    assert_equal instance.valid_options.object_id, instance.valid_options.object_id
  end
end

# required_options
# ----------------
class IQ::Storage::Adapters::Fs::RequiredOptionsTest < Test::Unit::TestCase
  def test_should_not_require_any_options
    assert_equal [], Factory.new_valid_fs_adapter.required_options
  end
end