# A FormBuilder that makes intelligent decisions about how a form field
# should be displayed based on ActiveRecord's Column object.
# 
# If the Column objects queried implement +options+ and/or +options+
# method(s), then these are also used to determine how the form fields
# should be presented.
# 
# The Column object's +options+ will always take precedence over any
# auto or supplied options.
# 
# Examples:
#   <% form_for @product do |f| %>
#     <%= f.label :title %>
#     <%= f.field :title %>
#   <% end %>
# 
#   <% form_for @product do |f| %>
#     <% for column in Product.content_columns %>
#       <%= f.label column %>
#       <%= f.field column %>
#     <% end %>
#   <% end %>
# 
class IQ::Helper::FormBuilder < ActionView::Helpers::FormBuilder
  
  # Merge in column.options if they exist
  ((field_helpers - %w(check_box radio_button fields_for)) + 
  %w(date_select datetime_select time_select)).each do |selector|
    src = <<-end_src
      def #{selector}(method_or_column, options = {})
        delegate_to_template(#{selector.inspect}, method_or_column, options)
      end
    end_src
    class_eval src, __FILE__, __LINE__
  end
  
  # TODO: Test and RDoc
  def draw(method_or_column, options = {})
    validate_options!(options)
    column = resolve_column!(method_or_column)
    @template.html_escape(object.send(column.name))
  end
  
  # TODO: Test and RDoc
  def select(method_or_column, options = {})
    validate_options!(options)
    column = resolve_column(method_or_column, options['postback'])
    collection_option = (options[:collection] || column.options[:collection])
    raise ArgumentError, 'A collection option must be given' unless collection_option
    collection = case collection_option
      when Proc : collection_option.call
      when Symbol : object.class.send(collection_option)
      when Array : collection_option
      else raise ArgumentError, 'collection option must be a Proc, Symbol or Array'
    end
    blank_value = options[:blank] || (column.respond_to?(:options) && column.options[:blank])
    collection.unshift([blank_value, nil]) if blank_value
    @template.select @object_name, column.name, collection, :selected => object.send(column.name)
  end
  
  # Proxy to relevant helper based on <tt>column.options[:helper]</tt> or
  # calculated from <tt>column.type</tt> respectively.
  def field(method_or_column, options = {})
    validate_options!(options)
    column = resolve_column!(method_or_column, options['postback'])
    
    send(
      column.respond_to?(:helper) && column.helper || case column.type
        when :text                  : :text_area
        when :boolean               : :check_box
        when :date                  : :date_select
        when :datetime, :timestamp  : :datetime_select
        when :time                  : :time_select
        when :collection            : :collectable # TODO: Test
        when :group                 : :group
        else :text_field
      end, column, options
    )
  end
  
  # TODO: Test and rename
  def group(method_or_column, options = {})
    column  = resolve_column!(method_or_column)
    separator = options[:separator] || (column.respond_to?(:options) && column.options[:separator]) || ' '
    column.columns.map { |col| render col }.join(separator.to_s)
  end
  
  # TODO: Test
  def columns
    object.respond_to?(:content_columns) ? object.content_columns : object.class.content_columns
  end
  
  def persist_fields
    return '' unless object.respond_to?(:persist_columns)
    output = ''
    # TODO: Only need to draw id when there are postbacks defined for format (maybe object.postbacks?)
    output << hidden_field(:id) if (object.class.respond_to?(:persist?) && object.class.persist? && !object.new_record?)
    fields_for 'changes', object do |f|
      output << object.persist_columns.map { |column| f.hidden_field column.name }.join
    end
    output
  end
  

  # TODO: Test and allow different for partial to be set
  def collectable(method_or_column, options = {})
    column = resolve_column!(method_or_column)
    output = ''
    object.send(column.name).each_with_index do |item, counter|
      @template.fields_for "#{object_name}[#{column.name}][#{counter}]", item do |ff|
        output << @template.render(:partial => 'form', :locals => { :f => ff, :member => item })
      end
    end
    output
  end
  
  
  # Render a partial with self, the form object and column provided
  # as locals. Uses default partial of 'simple' if none specified in
  # column or options
  def render(method_or_column)
    column  = resolve_column!(method_or_column)
    partial = column.partial if column.respond_to?(:partial)
    partial ||= "widgets/#{column.widget}" if column.respond_to?(:widget) && column.widget
    partial ||= 'widgets/simple'
    @template.render :partial => partial, :locals => { :f => self, :column => column }
  end
  
  # Returns label tag based on <tt>column.options[:label]</tt> or
  # <tt>column.human_name</tt> respectively or calculates from first argument
  # if a symbol or string.
  def label(method_or_column, options = {})
    validate_options!(options)
    
    if column = resolve_column(method_or_column)
      if column.respond_to?(:label)
        options[:text]  = column.label if column.label
        options[:notes] = column.notes if column.notes
      else
        options[:text] ||= column.human_name
      end
    end
    
    @template.label(object_name, (column && column.name || method_or_column), options.merge(:object => object))
  end
  
  # Creates a button tag
  def button(method_or_column, options = {})
    options = options.stringify_keys
    column = resolve_column!(method_or_column, options['postback'])
    method_name = ((column && column.name) || method_or_column).to_s
    options.reverse_merge!(column.options.stringify_keys) if column && column.respond_to?(:options)
    postback = extract_postback(column, options)
    options['value'] = nil unless options.has_key?('value')
    if (postback && method_name.eql?('commit'))
      options['text'] ||= postback.to_s.split('/').reverse.join(' ').humanize
    end
    delegate_to_template(:button, column || method_or_column, options)
  end
  
  def tag_id(method_or_column)
    column = resolve_column!(method_or_column)
    "#{@template.dom_id(object)}_#{column.name}"
  end
  
  # Calls the standard text_field helper, but calculates <tt>:size</tt> and
  # <tt>:maxlength</tt> options from the column object if it is available.
  # 
  # Both <tt>:maxlength</tt> and <tt>:size</tt> are determined by the column
  # +limit+, however <tt>:size</tt> adds 2 (to stop input from overflowing 
  # in browser) and is capped at 30.
  # 
  # If the Column object implements an +options+ method, then these
  # are merged in and take precedence over any auto or supplied options.
  def text_field(method_or_column, options = {})
    options = options.stringify_keys
    if column = resolve_column(method_or_column, options['postback'])
      auto_size_and_maxlength!(column, options)
    end
    delegate_to_template(:text_field, column || method_or_column, options)
  end
  
  # Functions in the same way as text_field.
  def password_field(method_or_column, options = {})
    options = options.stringify_keys
    if column = resolve_column(method_or_column, options['postback'])
      auto_size_and_maxlength!(column, options)
    end
    delegate_to_template(:password_field, column || method_or_column, options)
  end
  
  # Adds in a default <tt>:rows</tt> option of 10 if not already set.
  # 
  # If the Column object implements an +options+ method, then these
  # are merged in and take precedence over any auto or supplied options.
  def text_area(method_or_column, options = {})
    options[:rows] ||= 10
    delegate_to_template('text_area', method_or_column, options)
  end
  
  # TODO: Test
  def uploadify_file_field(method_or_column, options = {})
    delegate_to_template('uploadify_file_field', method_or_column, options)
  end
  
  # TODO: Test
  # NOTE: Additional args are to ensure backward compatability with rails form builder
  def check_box(method_or_column, options = {}, checked_value = '1', unchecked_value = '0')
    additional_args = [
      options.delete(:checked_value)    || checked_value,
      options.delete(:unchecked_value)  || unchecked_value
    ]
    delegate_to_template('check_box', method_or_column, options, *additional_args)
  end
  
  # TODO: Radio buttons are a bit special in Rails as they have an additional
  # arg before options (also more helpers to adapt)
  
  #def date_select(*args)
  #  raise args.inspect
  #end
  
  private
  
  def extract_postback(column, options)
    extract_postback!(column, options.dup)
  end
  
  def extract_postback!(column, options)
    options.delete('postback') || (column && column.respond_to?(:postback) && column.postback)
  end
  
  def auto_size_and_maxlength!(column, options)
    limit = column.respond_to?(:limit) ? column.limit : nil
    options['maxlength'] ||= limit unless limit.nil?
    options['size']      ||= limit && limit <= 28 ? limit + 2 : 30
    options
  end
  
  def validate_options!(options)
    raise ArgumentError, 'Options must be supplied as Hash' unless options.is_a?(Hash)
  end
  
  def resolve_column(method_or_column, postback = nil)
    if method_or_column.is_a?(Symbol) || method_or_column.is_a?(String)
      object.column_for_attribute(*[method_or_column, postback].compact) if object
    elsif method_or_column.kind_of?(ActiveRecord::ConnectionAdapters::Column) || method_or_column.respond_to?(:name)
      method_or_column
    else
      raise ArgumentError, "Must be called with String, Symbol or Column object, was #{method_or_column.inspect}"
    end
  end
  
  # Same as resolve_column but raises instead of returning nil
  def resolve_column!(method_or_column, postback = nil)
    resolve_column(method_or_column, postback) || raise(
      ArgumentError, "Column object could not be found for: #{method_or_column}"
    )
  end
  
  def delegate_to_template(method, method_or_column, options = {}, *additional_args)
    options = options.stringify_keys
    column = resolve_column(method_or_column, options['postback'])
    options.reverse_merge!(column.options.stringify_keys) if column.respond_to?(:options)
    object_method = (column && column.name) || method_or_column 
    
    if postback = extract_postback!(column, options)
      options.reverse_merge!('value' => '')
      postback_namespaces = postback.to_s.split('/')
      postback = postback_namespaces.pop
      name_namespace = postback_namespaces.map { |postback_namespace| "[#{postback_namespace}]" }.join
      id_namespace = postback_namespaces.join('_')
      options['name'] = "#{object_name}#{name_namespace}[_#{postback}][#{object_method}]"
      options['id'] = [@template.dom_id(object), id_namespace, postback, object_method].reject(&:blank?).join('_')
    end
    
    options['value'] = options['value'].call(object) if options['value'].is_a?(Proc)
    
    #raise "#{(column && column.name) || method_or_column}" unless object_method.is_a?(String)
    
    @template.send(method, @object_name, object_method, options.merge(:object => @object), *additional_args)    
  end
end