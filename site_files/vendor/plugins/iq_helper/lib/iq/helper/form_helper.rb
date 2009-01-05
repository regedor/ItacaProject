module IQ::Helper::FormHelper
  # Returns a label tag that points to a specified attribute (identified by
  # +method+) on an object assigned to a template (identified by +object+).
  # Additional options on the input tag can be passed as a hash with +options+.
  # An alternate text label can be passed as a <tt>:text</tt> key to +options+.
  # 
  # Example (call, result).
  #   label('post', 'title')
  #     <label for="post_title">Title</label>
  # 
  #   label('post', 'title', 'text' => 'My title')
  #     <label for="post_title">My title</label>
  def label(object_name, method, options = {})
    notes = options.delete(:notes)
    output = ActionView::Helpers::InstanceTag.new(
      object_name, method, self, nil, options.delete(:object)
    ).to_label_tag(options.delete(:text), options.stringify_keys)
    output << ('<br />' + content_tag('small', h(notes))) if notes
    output
  end
  
  def button(object_name, method, options = {})
    options = options.stringify_keys
    ActionView::Helpers::InstanceTag.new(
      object_name, method, self, nil, options.delete('object')
    ).to_button_tag(options.delete('text'), options)
  end
  
  def button_tag(text, options = {})
    options = options.stringify_keys
    content_tag('button', html_escape(text), { :name => 'commit' }.merge(options))
  end
  
  # Creates a label tag.
  #   label_tag('post_title', 'Title')
  #     <label for="post_title">Title</label>
  def label_tag(name, text, options = {})
    content_tag('label', text, { 'for' => name }.merge(options.stringify_keys))
  end
  
  def form_for(record_or_name_or_array, *args, &proc)
    return super if record_or_name_or_array.is_a?(Array)

    namespace = controller.controller_path.split('/')
    namespace.pop

    case record_or_name_or_array
      when String, Symbol
        options = args.extract_options!
        apply_form_for_options!((namespace << args.first), options) unless args.blank?
        args << options
      else
        record_or_name_or_array = namespace << record_or_name_or_array
    end
    
    super(record_or_name_or_array, *args, &proc)
  end
end