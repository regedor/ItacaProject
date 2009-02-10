require File.join(File.dirname(__FILE__), 'unit_test_helper')

# self.default_storage_adapter
# ----------------------------
class IQ::Storage::AdapterRegistry::ClassMethods::DefaultAdapterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.adapter_registry_enabled_class, :default_storage_adapter
  end

  def test_should_be_set_to_nil_by_default
    assert_nil Factory.adapter_registry_enabled_class.default_storage_adapter
  end
end

# self.default_storage_adapter=
# -----------------------------
class IQ::Storage::AdapterRegistry::ClassMethods::DefaultAdapterSetterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.adapter_registry_enabled_class, :default_storage_adapter=
  end

  def test_should_change_default_storage_adapter_result
    klass = Factory.adapter_registry_enabled_class
    klass.register_storage_adapter(:db) {}
    klass.default_storage_adapter = :db
    assert_equal :db, klass.default_storage_adapter
  end
  
  def test_should_raise_unregistered_storage_adapter_error_when_adapter_not_registered
    klass = Factory.adapter_registry_enabled_class
    assert_raises(klass::Exceptions::UnregisteredAdapterError) do
      klass.default_storage_adapter = :unregistered
    end
  end
end

# storage_adapters
# ----------------
class IQ::Storage::AdapterRegistry::StorageAdaptersTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.adapter_registry_enabled_class, :storage_adapters
  end

  def test_should_return_hash
    assert_instance_of Hash, Factory.adapter_registry_enabled_class.storage_adapters
  end
end

# self.register_storage_adapter
# -----------------------------
class IQ::Storage::AdapterRegistry::ClassMethods::RegisterStorageAdapterTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.adapter_registry_enabled_class, :register_storage_adapter
  end

  def test_should_accept_symbol
    assert_nothing_raised(ArgumentError) do
      Factory.adapter_registry_enabled_class.register_storage_adapter(:my_storage) {}
    end 
  end

  def test_should_raise_when_no_block_given
    assert_raises(ArgumentError) do
      Factory.adapter_registry_enabled_class.register_storage_adapter(:my_storage)
    end 
  end

  def test_should_store_block_as_proc_in_storage_adapters_hash_with_symbol_as_key
    klass = Factory.adapter_registry_enabled_class
    klass.register_storage_adapter :my_storage do
      'foo'
    end 
    assert_equal 'foo', klass.storage_adapters[:my_storage].call
  end
end