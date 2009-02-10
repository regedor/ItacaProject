require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# initialize
# ----------
class IQ::Storage::Adapters::Base::InitializeTest < Test::Unit::TestCase
  def test_should_accept_options_hash
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter }
  end
  
  def test_should_raise_when_options_is_not_a_hash
    assert_raise(ArgumentError) { Factory.new_base_adapter('not a hash') }
  end
  
  def test_should_not_raise_when_no_argument_given
    assert_nothing_raised(ArgumentError) { Factory.new_base_adapter }
  end
  
  def test_should_validate_options
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:valid_option])
    assert_raise(ArgumentError) { Factory.new_base_adapter({ :invalid_option => 'value'}) }
    assert_nothing_raised(ArgumentError) { Factory.new_base_adapter({ :valid_option => 'value'}) }
  end
  
  def test_should_raise_if_required_options_are_not_given
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:required_option])
    IQ::Storage::Adapters::Base.any_instance.stubs(:required_options).returns([:required_option])
    assert_raise(ArgumentError) { Factory.new_base_adapter({}) }
    assert_nothing_raised(ArgumentError) { Factory.new_base_adapter({ :required_option => 'value'}) }
  end
  
  def test_should_set_options_instance_variable_to_value_of_options_argument
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:valid_option])
    instance = Factory.new_base_adapter({ :valid_option => 'value'})
    assert_equal({ :valid_option => 'value'}, instance.instance_variable_get('@options'))
  end
  
  def test_should_use_default_options_that_are_not_supplied
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:valid_option, :another_option])
    IQ::Storage::Adapters::Base.any_instance.stubs(:default_options).returns({:another_option => 'fooey'})
    instance = Factory.new_base_adapter({ :valid_option => 'value'})
    assert_equal({ :valid_option => 'value', :another_option => 'fooey' }, instance.instance_variable_get('@options'))
  end
  
  def test_should_merge_supplied_options_into_defaults
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:valid_option, :another_option])
    IQ::Storage::Adapters::Base.any_instance.stubs(:default_options).returns({:another_option => 'fooey'})
    instance = Factory.new_base_adapter({ :valid_option => 'value', :another_option => 'barey' })
    assert_equal({ :valid_option => 'value', :another_option => 'barey' }, instance.instance_variable_get('@options'))
  end

  def test_should_validate_default_options
    IQ::Storage::Adapters::Base.any_instance.stubs(:valid_options).returns([:valid_option])
    IQ::Storage::Adapters::Base.any_instance.stubs(:default_options).returns({:another_option => 'fooey'})
    assert_raise(ArgumentError) { Factory.new_base_adapter({ :valid_option => 'value'}) }
  end
end

# store
# -----
class IQ::Storage::Adapters::Base::StoreTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :store
  end

  def test_should_require_two_arguments
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.store }
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.store('only one argument') }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.store('arg1', 'arg2') }
  end
  
  def test_should_require_first_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.store(:not_a_string, 'string') }
  end

  def test_should_require_second_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.store('string', :not_a_string) }
  end
  
  def test_should_not_raise_with_valid_arguments
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.store('string', 'string') }    
  end
end

# fetch
# -----
class IQ::Storage::Adapters::Base::FetchTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :fetch
  end

  def test_should_require_two_arguments
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.fetch }
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.fetch('only one argument') }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.fetch('arg1', 'arg2') }
  end
  
  def test_should_require_first_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.fetch(:not_a_string, 'string') }
  end

  def test_should_require_second_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.fetch('string', :not_a_string) }
  end
  
  def test_should_not_raise_with_valid_arguments
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.fetch('string', 'string') }    
  end
end

# erase
# ------
class IQ::Storage::Adapters::Base::EraseTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :erase
  end

  def test_should_require_one_argument
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.erase }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.erase('instance') }
  end
  
  def test_should_require_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.erase(:not_a_string) }
  end
end

# with_temp_file
# --------------
class IQ::Storage::Adapters::Base::WithTempFileTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :with_temp_file
  end

  def test_should_require_a_block
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.with_temp_file }
  end

  def test_should_instanciate_tempfile_with_random_filename_and_default_tmp_dir
    Time.stubs(:now).returns(stub(:to_i => 'an int', :usec => 'the usec'))
    Process.stubs(:pid).returns('the pid')
    Tempfile.expects(:new).with("an int.the usec.the pid", Dir::tmpdir)
    Factory.new_valid_base_adapter.with_temp_file() {}
  end

  def test_should_instanciate_tempfile_with_tempfile_base_option_as_second_argument_when_set
    Time.stubs(:now).returns(stub(:to_i => 'an int', :usec => 'the usec'))
    Process.stubs(:pid).returns('the pid')
    Tempfile.expects(:new).with("an int.the usec.the pid", '/temp/base')
    Factory.new_valid_base_adapter(:tempfile_base => '/temp/base').with_temp_file() {}
  end

  def test_should_yield_new_tempfile
    Time.stubs(:now).returns(stub(:to_i => 'an int', :usec => 'the usec'))
    Process.stubs(:pid).returns('the pid')
    mock_tempfile = stub_everything
    Tempfile.stubs(:new).with("an int.the usec.the pid", '/temp/base').returns(mock_tempfile)
    Factory.new_valid_base_adapter(:tempfile_base => '/temp/base').with_temp_file() do |tempfile|
      assert_equal mock_tempfile, tempfile
    end
  end

  def test_should_return_value_of_block_call
    Time.stubs(:now).returns(stub(:to_i => 'an int', :usec => 'the usec'))
    Process.stubs(:pid).returns('the pid')
    mock_tempfile = stub_everything
    Tempfile.stubs(:new).with("an int.the usec.the pid", '/temp/base').returns(mock_tempfile)
    assert_equal 'result', Factory.new_valid_base_adapter(:tempfile_base => '/temp/base').with_temp_file() { 'result' }
  end

  def test_should_ensure_that_tempfile_is_closed_and_immediately_unlinked
    Time.stubs(:now).returns(stub(:to_i => 'an int', :usec => 'the usec'))
    Process.stubs(:pid).returns('the pid')
    mock_tempfile = stub_everything
    mock_tempfile.expects(:close).with(true)
    Tempfile.stubs(:new).with("an int.the usec.the pid", '/temp/base').returns(mock_tempfile)
    Factory.new_valid_base_adapter(:tempfile_base => '/temp/base').with_temp_file() { raise } rescue nil
  end
end



# relative_path
# -------------
class IQ::Storage::Adapters::Base::RelativePathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :relative_path
  end

  def test_should_require_one_argument
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.relative_path }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.relative_path('the/path') }
  end

  def test_should_require_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.relative_path(:not_a_string) }
  end
end

# absolute_path
# -------------
class IQ::Storage::Adapters::Base::AbsolutePathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :absolute_path
  end

  def test_should_require_one_argument
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.absolute_path }
    assert_nothing_raised(ArgumentError) { Factory.new_valid_base_adapter.absolute_path('the/path') }
  end

  def test_should_require_argument_as_string
    assert_raise(ArgumentError) { Factory.new_valid_base_adapter.absolute_path(:not_a_string) }
  end
end

# options
# -------
class IQ::Storage::Adapters::Base::OptionsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :options
  end

  def test_should_return_value_of_options_instance_variable
    instance = Factory.new_valid_base_adapter
    instance.instance_variable_set '@options', 'fooey'
    assert_equal 'fooey', instance.options
  end
end

# default_options
# ---------------
class IQ::Storage::Adapters::Base::DefaultOptionsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :default_options
  end

  def test_should_return_empty_hash
    assert_equal({}, Factory.new_valid_base_adapter.default_options)
  end
end

# required_options
# ----------------
class IQ::Storage::Adapters::Base::RequiredOptionsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :required_options
  end

  def test_should_return_empty_array
    assert_equal [], Factory.new_valid_base_adapter.required_options
  end
end

# valid_options
# -------------
class IQ::Storage::Adapters::Base::ValidOptionsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.new_valid_base_adapter, :valid_options
  end

  def test_should_return_base_valid_options
    assert_equal [:tempfile_base], Factory.new_valid_base_adapter.valid_options
  end
end





