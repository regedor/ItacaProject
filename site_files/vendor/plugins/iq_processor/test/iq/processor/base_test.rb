require File.join(File.dirname(__FILE__), 'unit_test_helper')

# self.included
# -------------
class IQ::Processor::Base::SelfIncludedTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Processor::Base, :included
  end

  def test_should_accept_one_argument
    assert_nothing_raised { IQ::Processor::Base.included(stub_everything()) }
  end

  def test_should_define_has_many_relationship_on_supplied_class_using_its_name_as_the_class_name_option
    klass = stub_everything(:name => 'TempClass')
    klass.expects(:has_many).with(
      :versions, :class_name => 'TempClass', :foreign_key => 'base_version_id', :dependent => :destroy
    )
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    IQ::Processor::Base.included(klass)
  end

  # REVIEW: This is testing the association proxy method gets created. If there
  # was a was to catch the block that gets passed to has_many using Mocha this
  # could be much cleaner but can't find a simple way.
  def test_should_define_association_proxy_on_has_many_relationship_that_returns_version_with_matching_supplied_name
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        collection = [
          stub(:version_name => 'thumb' , :title => 'Littlen', :base_version= => nil, :new_record? => false),
          stub(:version_name => 'medium', :title => 'Average', :base_version= => nil, :new_record? => false),
          stub(:version_name => 'large',  :title => 'Hoofing', :base_version= => nil, :new_record? => false)
        ]
        collection.stubs(:proxy_owner).returns(stub_everything)
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil, 'medium' => nil, 'large' => nil})
    
    IQ::Processor::Base.included(klass)
    
    instance = klass.new
    instance.stubs(:requires_storage?)
    instance.collection.stubs(:proxy_owner).returns(instance)
    
    assert_equal 'Average', instance.collection[:medium].title
    assert_equal 'Hoofing', instance.collection['large'].title
  end
  
  def test_should_raise_when_association_proxy_tries_to_access_invalid_version
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        collection = [
          stub(:version_name => 'thumb' , :title => 'Littlen', :base_version= => nil),
          stub(:version_name => 'medium', :title => 'Average', :base_version= => nil),
          stub(:version_name => 'large',  :title => 'Hoofing', :base_version= => nil)
        ]
        
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil, 'medium' => nil, 'large' => nil})
    
    IQ::Processor::Base.included(klass)

    instance = klass.new
    instance.stubs(:requires_storage?)
    instance.collection.stubs(:proxy_owner).returns(instance)
    
    assert_raises(ActiveRecord::RecordNotFound) { instance.collection[:non_existent].title }
  end
  
  def test_should_build_version_when_association_proxy_tries_to_access_valid_version_that_does_not_exist
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        collection = [
          stub(:version_name => 'thumb' , :title => 'Littlen', :base_version= => nil)
        ]
        
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil, 'medium' => nil})
    
    IQ::Processor::Base.included(klass)

    instance = klass.new
    instance.stubs(:requires_storage?)
    instance.collection.stubs(:proxy_owner).returns(instance)
    
    instance.collection.expects(:build).with({ :version_name => 'medium' }).returns(stub_everything)
    
    instance.collection['medium']
  end
  
  def test_should_set_versions_base_version_to_proxy_owner_to_save_on_queries_when_association_proxy_accesses_version
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        collection = [
          stub(:version_name => 'thumb' , :title => 'Littlen', :new_record? => false)
        ]                                                    
                                                             
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil})
    
    IQ::Processor::Base.included(klass)

    instance = klass.new
    instance.stubs(:requires_storage?)
    instance.collection.stubs(:proxy_owner).returns(instance)
    instance.collection.first.expects(:base_version=).with(instance)
    instance.collection['thumb']
  end
  
  def test_should_save_version_when_association_proxy_accesses_version_and_proxy_owner_requires_storage
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        my_version = stub(:version_name => 'thumb' , :title => 'Littlen')
        my_version.stubs(:base_version=)
        my_version.expects(:save)
        collection = [
          my_version
        ]
        
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil})
    
    IQ::Processor::Base.included(klass)

    instance = klass.new
    instance.stubs(:requires_storage?).returns(true)
    instance.collection.stubs(:proxy_owner).returns(instance)
    instance.collection['thumb']
  end
  
  def test_should_build_and_save_version_when_association_proxy_tries_to_access_valid_version_that_does_not_exist
    klass = Class.new do
      extend Mocha::AutoVerify
      
      def self.has_many(*args, &block)
        collection = [
          stub(:version_name => 'thumb' , :title => 'Littlen', :base_version= => nil)
        ]
        
        collection.instance_eval &block
        
        define_method :collection do
          collection
        end
      end      
    end
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    klass.stubs(:belongs_to)
    klass.stubs(:version_handlers).returns({'thumb' => nil, 'medium' => nil})
    
    IQ::Processor::Base.included(klass)

    instance = klass.new
    instance.stubs(:requires_storage?)
    instance.collection.stubs(:proxy_owner).returns(instance)
    
    new_version_mock = mock()
    new_version_mock.stubs(:new_record?).returns(true)
    new_version_mock.stubs(:base_version=)
    new_version_mock.expects(:save)
    
    instance.collection.stubs(:build).with({ :version_name => 'medium' }).returns(new_version_mock)
    
    instance.collection['medium']
  end
  
  def test_should_set_callbacks
    klass = stub_everything
    klass.expects(:before_save).with(:process_base_version)
    klass.expects(:after_save).with(:generate_versions)
    klass.expects(:before_save).with(:process_versions)
    IQ::Processor::Base.included(klass)
  end

  def test_should_define_belongs_to_relationship_on_supplied_class_using_its_name_as_the_class_name_option
    klass = stub_everything(:name => 'TempClass')
    klass.expects(:belongs_to).with(:base_version, :class_name => 'TempClass', :foreign_key => 'base_version_id')
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    IQ::Processor::Base.included(klass)
  end

  def test_should_call_extend_on_argement_to_include_class_methods_module
    klass = stub_everything(:name => 'TempClass')
    klass.expects(:extend).with(IQ::Processor::Base::ClassMethods)
    
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    
    IQ::Processor::Base.included(klass)
  end
end

# process_base_version
# --------------------
class IQ::Processor::Base::ProcessBaseVersionTest < Test::Unit::TestCase
  def test_should_respond
    klass = Factory.basic_asset_class_with_process
    assert_respond_to klass.new, :process_base_version
  end

  def test_should_not_handle_version_unless_base_version
    klass = Factory.basic_asset_class_with_process
    
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    klass.expects(:base_version_handler).never
    assert_nil instance.process_base_version
  end

  def test_should_not_handle_version_unless_base_version_handler_defined
    klass = Factory.basic_asset_class_with_process
    
    instance = klass.new
    instance.stubs(:base_version?).returns(true)
    instance.stubs(:base_version?)
    version_handler = stub
    version_handler.expects(:process_proc).never
    klass.stubs(:base_version_handler).returns(version_handler)
    assert_nil instance.process_base_version
  end

  def test_should_process_base_version_with_base_version_handler_with_instance_and_temp_path
    klass = Factory.basic_asset_class_with_process

    version_handler = IQ::Processor::VersionHandler.new() { |canvas| canvas }
    klass.stubs(:base_version_handler).returns(version_handler)
    
    instance = klass.new
    
    instance.stubs(:base_version?).returns(true)
    instance.stubs(:temp_path).returns('/path/to/file')
    version_handler.expects(:process).with(instance, '/path/to/file')
    instance.process_base_version
  end
end

# base_version?
# -------------
class IQ::Processor::Base::BaseVersionBoolTest < Test::Unit::TestCase
  def test_should_respond
    klass = Factory.basic_asset_class_with_process
    assert_respond_to klass.new, :base_version?
  end

  def test_should_return_false_if_base_version_id_is_set
    klass = Factory.basic_asset_class_with_process
    instance = klass.new
    instance.stubs(:base_version_id).returns(1)
    assert_equal false, instance.base_version?
  end

  def test_should_return_true_if_base_version_id_is_not_set
    klass = Factory.basic_asset_class_with_process
    instance = klass.new
    instance.stubs(:base_version_id)
    assert_equal true, instance.base_version?
  end
end

# generate_versions
# -----------------
class IQ::Processor::Base::GenerateVersionsTest < Test::Unit::TestCase
  def test_should_respond
    klass = Factory.basic_asset_class_with_process
    assert_respond_to klass.new, :generate_versions
  end

  def test_should_not_generate_versions_if_model_instance_is_not_base_version
    klass = Factory.basic_asset_class_with_process
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.expects(:versions).never
    instance.generate_versions
  end

  def test_should_not_generate_versions_if_model_instance_does_not_require_storage
    klass = Factory.basic_asset_class_with_process
    instance = klass.new
    instance.stubs(:base_version?).returns(true)
    instance.stubs(:requires_storage?).returns(false)
    instance.expects(:versions).never
    instance.generate_versions
  end
  
  def test_should_generate_versions
    klass = Factory.basic_asset_class_with_process
    
    klass.stubs(:version_handlers).returns({'thumb' => nil})
    
    instance = klass.new
    instance.stubs(:versions).returns([])
    instance.stubs(:base_version?).returns(true)
    instance.stubs(:requires_storage?).returns(true)
    instance.stubs(:base_version).returns(stub(:new_record? => false))
    instance.versions.expects(:[]).with('thumb')
    instance.generate_versions
  end
end

# process_versions
# ----------------
class IQ::Processor::Base::ProcessVersionsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.basic_asset_class_with_process.new, :process_versions
  end

  def test_should_not_process_if_instance_is_a_base_version
    instance = Factory.basic_asset_class_with_process.new
    instance.stubs(:base_version?).returns(true)
    instance.expects(:storage_adapter).never
    assert_nil instance.process_versions
  end
  
  def test_should_not_process_versions_when_base_version_not_saved
    instance = Factory.basic_asset_class_with_process.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:base_version).returns(stub(:new_record? => true))
    instance.expects(:storage_adapter).never
    assert_nil instance.process_versions
  end
  
  def test_should_return_if_no_matching_version_handler_for_version_name
    klass = Factory.basic_asset_class_with_process
    
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:base_version).returns(stub(:new_record? => false))
    instance.stubs(:version_name).returns('thumb')

    instance.expects(:storage_adapter).never
    assert_nil instance.process_versions
  end
  
  def test_should_create_tempfile_via_with_temp_file_and_return_result_of_with_temp_file_call
    klass = Factory.basic_asset_class_with_process
    klass.stubs(:version_handlers).returns({ 'thumb' => 'a version handler' })
    
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:base_version).returns(stub(:new_record? => false))
    instance.stubs(:version_name).returns('thumb')

    instance.stubs(:storage_adapter).returns(mock(:with_temp_file => 'done'))
    
    assert_equal 'done', instance.process_versions
  end
  
  def test_should_fetch_from_base_version_storage_path_to_tempfile_path_then_process_then_store
    klass = Factory.basic_asset_class_with_process
    mock_version_handler = 'a version handler'
    mock_version_handler.stubs(:process)

    klass.stubs(:version_handlers).returns({ 'thumb' => mock_version_handler })
    
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    
    mock_base_version = stub
    mock_base_version.stubs(:storage_path).returns('/a/storage/path')
    mock_base_version.stubs(:new_record?).returns(false)
    mock_base_version_storage_adapter = mock
    mock_base_version.stubs(:storage_adapter).returns(mock_base_version_storage_adapter)
    
    instance.stubs(:base_version).returns(mock_base_version)
    instance.stubs(:version_name).returns('thumb')
    instance.stubs(:storage_path).returns('/another/storage/path')
    
    mock_storage_adapter = stub
    mock_storage_adapter.stubs(:with_temp_file).yields(stub(:path => 'a/temp/path'))
    instance.stubs(:storage_adapter).returns(mock_storage_adapter)
    
    # Expectations
    mock_base_version_storage_adapter.expects(:fetch).with('/a/storage/path', 'a/temp/path')
    mock_version_handler.expects(:process).with(instance, 'a/temp/path')
    mock_storage_adapter.expects(:store).with('a/temp/path', '/another/storage/path')
    
    instance.process_versions
  end
  
end

# instance_dir
# ------------
class IQ::Processor::Base::InstanceDirTest < Test::Unit::TestCase
  def test_should_return_super_if_base_version
    klass = Class.new
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    instance = klass.new
    instance.stubs(:base_version?).returns(true)
    assert_raises(NoMethodError, "super: no superclass method `instance_dir'") { instance.instance_dir }
  end

  def test_should_return_instance_dir_of_base_version_if_not_base_version
    klass = Class.new
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:base_version).returns(stub(:instance_dir => 'base version instance dir'))
    assert_equal 'base version instance dir', instance.instance_dir
  end
end

# storage_adapter
# ---------------
class IQ::Processor::Base::StorageAdapterTest < Test::Unit::TestCase
  def test_should_return_super_if_base_version_and_super_method_does_not_error
    klass = Class.new
    klass.class_eval do
      def storage_adapter
        'test'
      end
    end
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    instance = klass.new
    instance.stubs(:base_version?).returns(true)
    assert_equal 'test', instance.storage_adapter
  end

  def test_should_return_result_of_storage_proc_of_version_handler_for_instances_version_name_if_it_exists
    klass = Class.new
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    
    klass.stubs(:version_handlers).returns({
      'thumb' => stub(:storage_adapter => stub(:call => 'version adapter storage proc'))
    })
    
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:version_name).returns('thumb')
    
    assert_equal 'version adapter storage proc', instance.storage_adapter
  end

  def test_should_return_default_storage_adapter_if_base_version_and_super_errors_and_no_version_handler_exists
    klass = Class.new
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    klass.stubs(:version_handlers).returns({})
    instance = klass.new
    instance.stubs(:base_version?).returns(true)
    instance.stubs(:version_name).returns('thumb')
    IQ::Processor::Config.storage_adapters[IQ::Processor::Config.default_storage_adapter].expects(:call).returns(
      'default storage adapter'
    )
    assert_equal 'default storage adapter', instance.storage_adapter
  end

  def test_should_return_base_version_storage_adapter_if_not_base_version_and_super_errors_and_no_version_handler_exists
    klass = Class.new
    klass.stubs(:after_validation)
    klass.stubs(:after_save)
    klass.stubs(:before_save)
    klass.stubs(:has_many)
    klass.stubs(:belongs_to)
    klass.send :include, IQ::Processor::Base
    klass.stubs(:version_handlers).returns({})
    instance = klass.new
    instance.stubs(:base_version?).returns(false)
    instance.stubs(:version_name)
    instance.stubs(:base_version).returns(stub(:storage_adapter => 'base version storage adapter'))
    assert_equal 'base version storage adapter', instance.storage_adapter
  end
end