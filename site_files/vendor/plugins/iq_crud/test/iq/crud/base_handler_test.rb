require File.join(File.dirname(__FILE__), 'test_helper')

# initialize
# ----------
class IQ::Crud::BaseHandler::InitializeTest < Test::Unit::TestCase
  def test_should_set_responses_instance_variable_to_empty_hash
    instance = Factory.base_handler_instance
    assert_equal({}, instance.instance_variable_get('@responses'))
  end
end

# responses
# ---------
class IQ::Crud::BaseHandler::ResponsesTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.base_handler_instance, :responses
  end

  def test_should_return_responses_instance_variable
    instance = Factory.base_handler_instance
    instance.instance_variable_set '@responses', 'my value'
    assert_equal 'my value', instance.responses
  end
end

# response_for
# ------------
class IQ::Crud::BaseHandler::ResponseForTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.base_handler_instance, :response_for
  end

  def test_should_accept_action_name_as_symbol
    assert_nothing_raised { Factory.base_handler_instance.response_for(:edit) {} }
  end

  def test_should_accept_multiple_action_names_as_symbols
    assert_nothing_raised { Factory.base_handler_instance.response_for(:show, :edit, :update) {} }
  end

  def test_should_raise_when_any_action_names_are_not_symbols
    assert_raise(ArgumentError) { Factory.base_handler_instance.response_for(:show, 'edit', :update) {} }
  end

  def test_should_raise_when_no_block_given
    assert_raise(ArgumentError) { Factory.base_handler_instance.response_for(:show, :edit) }
  end

  def test_should_yield_response_handler_instance_with_block_arity_of_1
    Factory.base_handler_instance.response_for :show do |format|
      assert_instance_of IQ::Crud::ResponseHandler, format
    end
  end

  def test_should_register_response_handler_formats_in_responses_hash_for_each_action
    instance = Factory.base_handler_instance
    html_proc = Proc.new { 'html page' }
    atom_proc = Proc.new { 'atom feed' }
    instance.response_for :show, :edit do |format|
      format.html &html_proc
      format.atom &atom_proc
    end
    assert_equal(
      {
        :show => [[:html, html_proc], [:atom, atom_proc]],
        :edit => [[:html, html_proc], [:atom, atom_proc]]
      },
      instance.responses
    )
  end

  def test_should_call_response_for_with_block_as_html_format_when_block_arity_less_than_one
    instance = Factory.base_handler_instance
    proc = Proc.new { 'the proc' }
    instance.response_for :new, :edit, &proc
    assert_equal(
      { :new  => [[:html, proc]], :edit => [[:html, proc]] },
      instance.responses
    )
  end
  
  def test_should_add_new_format_procs_into_existing_array_when_no_format_of_type_already_exists
    instance = Factory.base_handler_instance
    html_proc = Proc.new { 'html page' }
    atom_proc = Proc.new { 'atom feed' }
    instance.responses[:edit] = [[:html, html_proc]]
    
    instance.response_for :edit do |format|
      format.atom &atom_proc
    end
    
    assert_equal({ :edit => [[:html, html_proc], [:atom, atom_proc]] }, instance.responses)  
  end
  
  def test_should_merge_new_procs_into_existing_array
    instance = Factory.base_handler_instance
    html_proc = Proc.new { 'html page' }
    new_html_proc = Proc.new { 'new html page' }
    atom_proc = Proc.new { 'atom feed' }
    instance.responses[:edit] = [[:html, html_proc], [:atom, atom_proc]]
    
    instance.response_for :new, :edit do |format|
      format.html &new_html_proc
    end
    
    assert_equal(
      { :edit => [[:html, new_html_proc], [:atom, atom_proc]], :new => [[:html, new_html_proc]] },
      instance.responses
    )  
  end
  
  def test_should_delete_procs_from_existing_array_when_format_given_nil
    instance = Factory.base_handler_instance
    html_proc = Proc.new { 'html page' }
    atom_proc = Proc.new { 'atom feed' }
    instance.responses[:edit] = [[:html, html_proc], [:atom, atom_proc]]
    
    instance.response_for :edit do |format|
      format.atom nil
    end
    
    assert_equal({ :edit =>  [[:html, html_proc]] }, instance.responses)
  end
end

