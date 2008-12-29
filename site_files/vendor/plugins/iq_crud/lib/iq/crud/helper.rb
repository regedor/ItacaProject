module IQ::Crud::Helper
  # Returns the current resource's columns, first looking for a +list_columns+
  # class method of resource class and then +content_columns+ respectively.
  # 
  # If the columns cannot be returned by +list_columns+, the +content_columns+
  # returned have a +title+ method added on-the-fly that proxy to +human_name+.
  def resource_columns
    RAILS_DEFAULT_LOGGER.debug 'DEPRECIATION: resource_columns is depreciated, use resource_columns_for(:list)'
    @resource_columns ||= begin
      if resource_class.respond_to?(:list_columns) && (columns = resource_class.list_columns)[0].respond_to?(:label)
        columns
      else 
        resource_class.content_columns.map do |column| 
          class << column
            def label
              human_name
            end
          end
          column
        end
      end
    end
  end
  
  # Returns the current resource's fields, first looking for a +fields+ class
  # method of resource class and then +content_columns+ respectively.
  def resource_fields
    RAILS_DEFAULT_LOGGER.debug 'DEPRECIATION: resource_fields is depreciated, use resource_columns_for(:form)'
    @resource_fields ||= resource_class.respond_to?(:fields) ? resource_class.fields : resource_class.content_columns
  end
  
  # TODO: Test and document
  def resource_columns_for(format)
    format = format.to_s
    @resource_columns_for ||= {}
    @resource_columns_for[format] ||= if resource_class.respond_to?(:columns_for) && resource_class.column_format_for?(format)
      resource_class.columns_for(format)
    else
      resource_class.content_columns
    end
  end
end