module IQ # :nodoc:
  module Helper # :nodoc:
    autoload :FormHelper,   File.join(File.dirname(__FILE__), 'helper/form_helper')
    autoload :FormBuilder,  File.join(File.dirname(__FILE__), 'helper/form_builder')
    autoload :InstanceTag,  File.join(File.dirname(__FILE__), 'helper/instance_tag')
  end
end

module ActionView # :nodoc:
  class Base # :nodoc:
    include IQ::Helper::FormHelper
    self.default_form_builder = IQ::Helper::FormBuilder
  end
  
  module Helpers
    class InstanceTag
      include IQ::Helper::InstanceTag
    end
  end
end