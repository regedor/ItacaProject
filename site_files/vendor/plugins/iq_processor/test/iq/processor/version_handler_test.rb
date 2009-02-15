require File.join(File.dirname(__FILE__), 'unit_test_helper')

# initialize
# ----------
class IQ::Processor::VersionHandler::InitializeTest < Test::Unit::TestCase
  def test_should_accept_options_hash
    IQ::Processor::VersionHandler.new(:storage => :fs) {}
  end
  
  def test_should_not_require_options_hash
    IQ::Processor::VersionHandler.new {}
  end

  def test_should_raise_when_options_is_not_a_hash
    assert_raise(ArgumentError) { IQ::Processor::VersionHandler.new('not a hash') {} }
  end

  def test_should_raise_when_option_with_invalid_key_is_supplied
    assert_raise(ArgumentError) { IQ::Processor::VersionHandler.new(:invalid => 'key') {} }
  end

  def test_should_raise_when_no_block_given
    assert_raise(ArgumentError) do
      IQ::Processor::VersionHandler.new
    end
  end

  def test_should_accept_storage_option
    assert_nothing_raised(ArgumentError) { IQ::Processor::VersionHandler.new(:storage => :fs) {} }
  end

  def test_should_raise_unless_storage_option_is_nil_or_symbol_or_proc
    assert_raise(ArgumentError) { IQ::Processor::VersionHandler.new(:storage => 'not sym or proc') {} }
    assert_nothing_raised(ArgumentError) do
      IQ::Processor::VersionHandler.new(:storage => :fs) {}
      IQ::Processor::VersionHandler.new(:storage => Proc.new {}) {}
    end
  end

  def test_should_set_storage_adapter_instance_variable_to_registered_proc_when_supplied_as_symbol
    version_handler = IQ::Processor::VersionHandler.new(:storage => :fs) {}
    assert_equal IQ::Processor::Config.storage_adapters[:fs], version_handler.storage_adapter
  end

  def test_should_set_storage_adapter_instance_variable_to_storage_option_when_supplied_as_proc
    proc = Proc.new {}
    version_handler = IQ::Processor::VersionHandler.new(:storage => proc) {}
    assert_equal proc, version_handler.storage_adapter
  end

  def test_should_raise_when_no_storage_adapter_with_name_corresponding_to_symbol_is_registered
    assert_raises(IQ::Processor::Exceptions::UnregisteredAdapterError) do
      IQ::Processor::VersionHandler.new(:storage => :non_existent_storage_adapter) {}
    end
  end
  
  def test_should_set_process_proc_instance_variable_to_provided_block
    proc = Proc.new {}
    version_handler = IQ::Processor::VersionHandler.new(:storage => :fs, &proc)
    assert_equal proc, version_handler.process_proc    
  end
  
  def test_should_accept_adapter_option
    assert_nothing_raised(ArgumentError) { IQ::Processor::VersionHandler.new(:adapter => :iq_image) {} }
  end
  
  def test_should_set_adapter_instance_variable_to_class_specified_by_adapter_option
    proc = Proc.new {}
    assert_equal(
      IQ::Processor::Adapters::IqImage,
      IQ::Processor::VersionHandler.new(:adapter => :iq_image, &proc).adapter
    ) 
  end
  
  def test_should_set_adapter_to_default_adapter_if_none_specified
    version_handler = IQ::Processor::VersionHandler.new() {}
    assert_equal(IQ::Processor::Adapters::IqImage, (IQ::Processor::VersionHandler.new() {}).adapter)
  end
  
  def test_should_raise_when_no_process_adapter_with_name_corresponding_to_symbol_is_registered
    assert_raises(IQ::Processor::Exceptions::UnregisteredAdapterError) do
      IQ::Processor::VersionHandler.new(:adapter => :non_existent_process_adapter) {}
    end
  end
  
  def test_should_accept_dir_option
    assert_nothing_raised(ArgumentError) { IQ::Processor::VersionHandler.new(:dir => 'public/img') {} }
  end
  
  def test_should_raise_if_dir_not_a_string
    assert_raises(ArgumentError) { IQ::Processor::VersionHandler.new(:dir => 1) {} }
    assert_raises(ArgumentError) { IQ::Processor::VersionHandler.new(:dir => :not_a_string) {} }
  end
  
  def test_should_set_storage_dir_instance_variable
    version_handler = IQ::Processor::VersionHandler.new(:dir => 'public/img') {}
    assert_equal 'public/img', version_handler.instance_variable_get('@storage_dir')
  end
end

# process_proc
# ------------
class IQ::Processor::VersionHandler::ProcessProcTest < Test::Unit::TestCase
  def test_should_respond
    version_handler = IQ::Processor::VersionHandler.new(:storage => Proc.new {}) {}
    assert_respond_to version_handler, :process_proc
  end

  def test_should_return_value_of_process_proc_instance_variable
    version_handler = IQ::Processor::VersionHandler.new(:storage => Proc.new {}) {}
    version_handler.instance_variable_set('@process_proc', 'test')
    assert_equal 'test', version_handler.process_proc
  end
end

# storage_adapter
# ---------------
class IQ::Processor::VersionHandler::StorageAdapterTest < Test::Unit::TestCase
  def test_should_respond
    version_handler = IQ::Processor::VersionHandler.new(:storage => Proc.new {}) {}
    assert_respond_to version_handler, :storage_adapter
  end

  def test_should_return_value_of_storage_adapter_instance_variable
    version_handler = IQ::Processor::VersionHandler.new(:storage => Proc.new {}) {}
    version_handler.instance_variable_set('@storage_adapter', 'test')
    assert_equal 'test', version_handler.storage_adapter
  end
end

# adapter
# -------
class IQ::Processor::VersionHandler::AdapterTest < Test::Unit::TestCase
  def test_should_respond
    version_handler = IQ::Processor::VersionHandler.new() {}
    assert_respond_to version_handler, :adapter
  end

  def test_should_return_value_of_storage_adapter_instance_variable
    version_handler = IQ::Processor::VersionHandler.new(:adapter => :iq_image) {}
    version_handler.instance_variable_set('@adapter', 'test')
    assert_equal 'test', version_handler.adapter
  end
end

# storage_dir
# -----------
class IQ::Processor::VersionHandler::StorageDirTest < Test::Unit::TestCase
  def test_should_respond
    version_handler = IQ::Processor::VersionHandler.new() {}
    assert_respond_to version_handler, :storage_dir
  end

  def test_should_return_value_of_storage_dir_instance_variable
    version_handler = IQ::Processor::VersionHandler.new(:dir => '/public/img') {}
    version_handler.instance_variable_set('@storage_dir', 'test')
    assert_equal 'test', version_handler.storage_dir
  end
end