module IQ # :nodoc:
  # == Example Usage
  # 
  # Examples:
  # 
  # with_options :dir => 'public/img/images' do |version|
  #   version.process(:thumb, :format => 'gif', :basename => :version_name) do |img|
  #     img.fit_to! 64, 64
  #   end
  #   
  #   version.process(:small, :format => 'png', :basename => Proc.new { "small-#{base_version_id}" }) do |img|
  #     img.fit_to! 128, 128
  #   end
  #   
  #   version.process(:large, :format => 'jpg', :basename => 'actual_name') do |img|
  #     img.fit_to! 480, 480
  #   end
  # end
  module Processor
    autoload :Base,           File.join(File.dirname(__FILE__), 'processor', 'base')
    autoload :Config,         File.join(File.dirname(__FILE__), 'processor', 'config')
    autoload :VersionHandler, File.join(File.dirname(__FILE__), 'processor', 'version_handler')
    autoload :Adapters,       File.join(File.dirname(__FILE__), 'processor', 'adapters')
   
    module Extensions # :nodoc:
      autoload :ActiveRecord, File.join(File.dirname(__FILE__), 'processor', 'extensions', 'active_record')
    end
    
    module Exceptions # :nodoc:
      class UnregisteredAdapterError < StandardError; end
    end
  end
end

ActiveRecord::Base.send(:extend, ::IQ::Processor::Extensions::ActiveRecord)
