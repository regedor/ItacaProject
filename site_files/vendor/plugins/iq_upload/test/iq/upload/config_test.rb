require File.join(File.dirname(__FILE__), 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Definition
# -----------------------------------------------------------------------------------------------
class IQ::Upload::Config::ClassDefinitionTest < Test::Unit::TestCase
  def test_should_include_storage_adapter_registry_module
    assert IQ::Upload::Config.included_modules.include?(IQ::Storage::AdapterRegistry)
  end
end

# -----------------------------------------------------------------------------------------------
# Self Methods
# -----------------------------------------------------------------------------------------------

# self.tempfile_path
# ------------------
class IQ::Upload::Config::SelfTempfilePathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Upload::Config, :tempfile_path
  end

  def test_should_have_default_path
    assert_equal(
      File.expand_path(File.join(RAILS_ROOT, 'tmp', 'uploads')), File.expand_path(IQ::Upload::Config.tempfile_path)
    )
  end
end

# self.tempfile_path=
# -------------------
class IQ::Upload::Config::SelfTempfilePathSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Upload::Config, :tempfile_path=
  end

  def test_should_retain_value_in_module
    duped = IQ::Upload::Config.dup
    duped.tempfile_path = 'foo'
    assert_equal 'foo', duped.tempfile_path
  end
end

# self.default_storage_adapter
# ----------------------------
class IQ::Upload::Config::SelfDefaultStorageAdapterTest < Test::Unit::TestCase
  def test_should_be_set_to_fs_by_default
    assert_equal :fs, IQ::Upload::Config.default_storage_adapter
  end
end

# self.storage_adapters
# ---------------------
class IQ::Upload::Config::SelfStorageAdaptersTest < Test::Unit::TestCase
  def test_should_have_fs_storage_adapter_registered_by_default
    adapter_proc = IQ::Upload::Config.storage_adapters[:fs]
    assert_instance_of Proc, adapter_proc, ':fs storage adapter should be registered by default'
  end
  
  def test_should_use_rails_root_for_absolute_base_with_fs_storage
    IQ::Storage::Adapters::Fs.expects(:new).with(
      :absolute_base => RAILS_ROOT, :relative_base => File.join(RAILS_ROOT, 'public')
    ).returns('storage adapter instance')
    
    # Proc needs to be called in context of class so that we can stub
    # read_inheritable_attribute with uploadify_options
    instance = Class.new { define_method :storage_adapter, &IQ::Upload::Config.storage_adapters[:fs] }.new
    assert_equal 'storage adapter instance', instance.storage_adapter
  end
  
  def test_should_have_s3_storage_adapter_registered_by_default
    adapter_proc = IQ::Upload::Config.storage_adapters[:s3]
    IQ::Storage::Adapters::S3.expects(:new).with().returns('s3 adapter')
    assert_instance_of Proc, adapter_proc, ':s3 storage adapter should be registered by default'
    assert_equal 's3 adapter', adapter_proc.call
  end
  
  def test_should_have_db_storage_adapter_registered_by_default
    adapter_proc = IQ::Upload::Config.storage_adapters[:db]
    IQ::Storage::Adapters::Db.expects(:new).with().returns('db adapter')
    assert_instance_of Proc, adapter_proc, ':db storage adapter should be registered by default'
    assert_equal 'db adapter', adapter_proc.call
  end
end

# self.default_storage_dir
# ------------------------
class IQ::Upload::Config::SelfDefaultStorageDirTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Upload::Config, :default_storage_dir
  end

  def test_should_have_default_path
    assert_equal File.join('public', 'assets'), IQ::Upload::Config.default_storage_dir
  end
end

# self.default_storage_dir=
# -------------------------
class IQ::Upload::Config::SelfDefaultStorageDirSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Upload::Config, :default_storage_dir=
  end

  def test_should_retain_value_in_module
    klass = IQ::Upload::Config
    existing_storage_dir = klass.default_storage_dir
    klass.default_storage_dir = 'foo'
    assert_equal 'foo', klass.default_storage_dir
    klass.default_storage_dir = existing_storage_dir
  end
end