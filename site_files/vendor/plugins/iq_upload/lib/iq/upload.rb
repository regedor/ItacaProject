module IQ # :nodoc:
  # TODO: General RDocs
  module Upload
    autoload :Base,                     File.join(File.dirname(__FILE__), 'upload', 'base')
    autoload :Config,                   File.join(File.dirname(__FILE__), 'upload', 'config')
    autoload :Backgroundrb,             File.join(File.dirname(__FILE__), 'upload', 'backgroundrb')
    autoload :MetaDataAccessors,        File.join(File.dirname(__FILE__), 'upload', 'meta_data_accessors')
    
    module Extensions # :nodoc:
      autoload :ActiveRecord, File.join(File.dirname(__FILE__), 'upload', 'extensions', 'active_record')
      autoload :ActionView,   File.join(File.dirname(__FILE__), 'upload', 'extensions', 'action_view')
    end
    
    module Exceptions # :nodoc:
      class NoFileColumnError < StandardError; end
      class OperationNotSupportedError < StandardError; end
      class UnregisteredProcessorError < StandardError; end
      class InvalidUploadTempFileError < StandardError; end
    end
  end
end

ActiveRecord::Base.send :extend, IQ::Upload::Extensions::ActiveRecord
ActionView::Base.send :include, IQ::Upload::Extensions::ActionView::FormHelper
ActionView::Helpers::FormBuilder.send :include, IQ::Upload::Extensions::ActionView::FormBuilder