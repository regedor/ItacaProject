require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Methods
# -----------------------------------------------------------------------------------------------

# self.uploadify
# --------------
class IQ::Upload::Extensions::ActiveRecord::SelfUploadTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.basic_asset_class, :uploadify
  end
  
  def test_should_accept_options_hash
    assert_nothing_raised(ArgumentError) { Factory.basic_asset_class.uploadify({}) }
  end
  
  def test_should_raise_when_options_is_not_a_hash
    assert_raise(ArgumentError) { Factory.basic_asset_class.uploadify('not a hash') }
  end
  
  def test_should_require_filename_column_on_model
    klass = Factory.basic_asset_class
    klass.stubs(:column_names).returns(['id'])
    assert_raises(IQ::Upload::Exceptions::NoFileColumnError) { klass.uploadify }
  end
  
  def test_should_raise_for_unexpected_options
    assert_raise(ArgumentError) { Factory.basic_asset_class.uploadify :strange_option => 'foo' }
  end
  
  def test_should_only_accept_symbol_for_storage_adapter_option
    assert_raise(ArgumentError) { Factory.basic_asset_class.uploadify :storage => nil }
    assert_nothing_raised(ArgumentError) do
      Factory.basic_asset_class.uploadify :storage => :db
    end
  end
  
  def test_should_include_base_module_on_first_call
    klass = Factory.basic_asset_class    
    klass.uploadify
    assert klass.included_modules.include?(IQ::Upload::Base), 'Base module should be included'
    klass.expects(:include).with(IQ::Upload::Base).never
    klass.uploadify
  end
  
  def test_should_include_backgroundrb_module_when_backgroundrb_option_is_set_to_true_on_first_call
    klass = Factory.basic_asset_class    
    klass.uploadify :backgroundrb => true
    assert klass.included_modules.include?(IQ::Upload::Backgroundrb), 'Backgroundrb module should be included'
    klass.expects(:include).with(IQ::Upload::Backgroundrb).never
    klass.uploadify :backgroundrb => true
  end
  
  def test_should_include_meta_data_accessors_module_on_first_call
    klass = Factory.basic_asset_class    
    klass.uploadify
    assert(
      klass.included_modules.include?(IQ::Upload::MetaDataAccessors), 'MetaDataAccessors module should be included'
    ) 
    klass.expects(:include).with(IQ::Upload::MetaDataAccessors).never
    klass.uploadify
  end
  
  def test_should_set_storage_adapter_from_storage_adapter_key
    klass = Factory.basic_asset_class
    adaptor_proc = Proc.new { 'my adapter' }
    IQ::Upload::Config.stubs(:storage_adapters).returns({ :my_adapter => adaptor_proc })
    klass.uploadify :storage => :my_adapter
    assert_equal 'my adapter', klass.new.storage_adapter  
  end
  
  def test_should_set_after_save_callback_for_store_upload
    klass = Factory.basic_asset_class    
    klass.expects(:after_save).with(:store_upload)
    klass.uploadify
  end
  
  def test_should_set_after_destroy_callback_for_remove_from_storage
    klass = Factory.basic_asset_class    
    klass.expects(:after_destroy).with(:remove_from_storage)
    klass.uploadify
  end
  
  def test_should_make_filename_column_protected
    klass = Factory.basic_asset_class    
    klass.uploadify
    assert klass.protected_attributes.map(&:to_s).include?('filename')
  end
  
  def test_should_create_attr_accessor_for_temp_path
    klass = Factory.basic_asset_class
    klass.uploadify
    instance = klass.new
    string = 'foo'
    instance.temp_path = string
    assert_equal string.object_id, instance.temp_path.object_id
  end
  
  def test_should_only_create_temp_path_attr_accessor_on_first_call
    klass = Factory.basic_asset_class
    klass.uploadify
    klass.expects(:attr_accessor).with(:temp_path).never
    klass.uploadify
  end
  
#  def test_should_write_inheritable_attribute_of_uploadify_options_on_first_call
#    klass = Factory.basic_asset_class
#    klass.expects(:write_inheritable_attribute).with(:uploadify_options, :backgroundrb => 'foo', :storage => :fs).once
#    2.times { klass.uploadify(:backgroundrb => 'foo') }
#  end

  def test_should_allow_dir_option
    assert_nothing_raised(ArgumentError) { Factory.basic_asset_class.uploadify(:dir => 'fooey') }
  end
  
  def test_should_raise_when_dir_option_is_not_string
    assert_raise(ArgumentError) { Factory.basic_asset_class.uploadify(:dir => :not_a_string) }
  end

  def test_should_store_dir_option_in_uploadify_options_inheritable_attribute
    klass = Factory.basic_asset_class
    klass.uploadify :dir => 'foo'
    assert_equal 'foo', klass.read_inheritable_attribute(:uploadify_options)[:dir]
  end
end