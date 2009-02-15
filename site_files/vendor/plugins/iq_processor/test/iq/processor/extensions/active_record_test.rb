require File.join(File.dirname(__FILE__), '../unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Methods
# -----------------------------------------------------------------------------------------------

# self.process
# ------------
class IQ::Processor::Extensions::ActiveRecord::SelfProcessTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.basic_asset_class, :process
  end

  def test_should_accept_suffix_as_first_argument
    assert_nothing_raised(ArgumentError) { Factory.basic_asset_class.process(:thumb) {} }
    assert_nothing_raised(ArgumentError) { Factory.basic_asset_class.process('thumb') {} }
  end
  
  def test_should_allow_no_suffix
    assert_nothing_raised(ArgumentError) { Factory.basic_asset_class.process() {} }
  end

  def test_should_raise_when_suffix_is_not_a_symbol_or_string
    assert_raise(ArgumentError) { Factory.basic_asset_class.process(321) {} }
  end
  
  def test_should_raise_when_no_block_given
    assert_raise(ArgumentError) { Factory.basic_asset_class.process(:thumb) }
  end

  def test_should_include_base_module_on_first_call
    klass = Factory.basic_asset_class    
    klass.process(:thumb) {}
    assert klass.included_modules.include?(IQ::Processor::Base)
    klass.expects(:include).with(IQ::Processor::Base).never
    klass.process('should not trigger another include') {}
  end
  
  def test_should_register_version_handler_with_process_options_in_version_handlers_hash_with_name_as_key
    klass = Factory.basic_asset_class
    proc = Proc.new { |image| image }
    IQ::Processor::VersionHandler.expects(:new).with(:storage => :fs, &proc).returns('version_handler')
    klass.process(:thumb, :storage => :fs, &proc)
    assert_equal({ 'thumb' => 'version_handler' }, klass.version_handlers)
  end
  
  def test_should_register_version_handler_for_base_version
    klass = Factory.basic_asset_class
    proc = Proc.new { |image| image }
    IQ::Processor::VersionHandler.expects(:new).with(:storage => :fs, &proc).returns('version_handler')
    klass.process(:storage => :fs, &proc)
    assert_equal('version_handler', klass.base_version_handler)
  end
end

