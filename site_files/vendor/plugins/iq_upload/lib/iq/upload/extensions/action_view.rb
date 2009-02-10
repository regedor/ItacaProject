module IQ::Upload::Extensions::ActionView
  module FormHelper 
    # Renders a file field for an asset model - along with an #uploadify_hidden_file_field
    # which keeps a record of uploaded files across form redisplays.
    # 
    # Note: 'uploaded_data' will be used when no 'method' argument supplied.
    # 
    # Examples:
    #   uploadify_file_field :product
    #   uploadify_file_field :product, :my_uploaded_data
    #   uploadify_file_field :product, :my_uploaded_data, :tempfile_method => 'already_got'
    # 
    # The output of this method will include a span with the filename of the
    # asset i.e. 'product-uploaded-file'.
    # 
    # Inteligent defaults will be used when a prefixed 'uploaded_data' method 
    # is used for example 'image_uploaded_data' will create a hidden field for
    # 'image_already_uploaded_data' and make a call to 'image_filename' when
    # displaying the filename. Also the class of the span that the filename is
    # output to will include 'image' i.e. 'product-image-uploaded-file'
    # 
    # 
    # Options:
    #   :tempfile_method  => 'my_tempfile_method' # Defaults to 'already_uploaded_data'
    #   :object           => my_object            # Defaults to object found via object_name
    def uploadify_file_field(*args)
      options = args.extract_options!
      raise ArgumentError, 'Too many arguments supplied' if args.size > 2  
      object_name, method = args
      
      default_data_method = 'uploaded_data'
      
      prefix = if method && method.to_s.ends_with?('_' + default_data_method)
        method.to_s.chomp(default_data_method)
      end
      
      unless object_name.is_a?(String) || object_name.is_a?(Symbol)
        raise ArgumentError, 'object_name must be a String or Symbol'
      end
      unless method.nil? || method.is_a?(String) || method.is_a?(Symbol)
        raise ArgumentError, 'method must be a String or Symbol'
      end
      raise ArgumentError, 'Options must be supplied as a Hash' unless options.is_a?(Hash)
      if (tempfile_method = options[:tempfile_method]) && !tempfile_method.is_a?(String)
        raise ArgumentError, ':tempfile_method option must be a String'
      end
      options.assert_valid_keys :tempfile_method, :object
      asset_model = options.delete(:object)
      
      filename = asset_model.nil? ? '' : asset_model.send("#{prefix}filename")
      
      result = "<span class=\"#{object_name.to_s.tr('_', '-')}-#{prefix && prefix.tr('_', '-')}uploaded-file\">#{filename}</span> "
      
      result << hidden_field(
        object_name, tempfile_method || "#{prefix}already_#{default_data_method}", options = {:object => asset_model}
      )
      result << ActionView::Helpers::InstanceTag.new(
        object_name, method || default_data_method, self, nil, asset_model
      ).to_input_field_tag("file", options)
    end
  end

  module FormBuilder # :nodoc:
    # See: IQ::Upload::Extensions::ActionView::FormHelper
    def uploadify_file_field(*args)
      options = args.extract_options!.merge(:object => @object)
      method = args.first
      @template.uploadify_file_field(@object_name, method, options)
    end
  end
end