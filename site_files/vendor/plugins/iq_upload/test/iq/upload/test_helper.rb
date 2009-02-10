# Path to root of plugin dir
PLUGIN_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..')
$:.unshift(File.join(PLUGIN_ROOT, 'lib'))

RAILS_ENV = 'test'
RAILS_ROOT = File.join(PLUGIN_ROOT, 'test', 'iq', 'upload', 'rails_root')

# Use vendor rails if possible
if File.directory?(rails_dir = File.join(PLUGIN_ROOT, '..', '..', 'rails'))
  %w(activerecord actionpack activesupport actionmailer).each { |dir| $:.unshift File.join(rails_dir, dir, 'lib') }
end

# Gems used for testing
require 'test/unit'
require 'rubygems'
require 'redgreen'

# Parts of rails used
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_controller/test_process'
require 'logger'
RAILS_DEFAULT_LOGGER = Logger.new(STDERR)

# Plugin Dependencies
$:.unshift File.join(PLUGIN_ROOT, '..', 'iq_storage', 'lib')
require 'iq/storage'

# Initialize the plugin
require 'iq/upload'

module Factory
  # BasicAsset
  # ----------
  def self.basic_asset_class
    build_active_record_class('BasicAsset')
  end
  
  def self.uploadified_basic_asset_class(*args)
    klass = basic_asset_class
    klass.uploadify *args
    klass
  end
  
  # MetaDataAsset
  # -------------
  def self.meta_data_asset_class
    build_active_record_class('MetaDataAsset')
  end
  
  def self.uploadified_meta_data_asset_class(*args)
    klass = meta_data_asset_class
    klass.uploadify *args
    klass
  end
  
  # FormHelperClass
  # ---------------
  def self.form_helper_class
    Class.new { include IQ::Upload::Extensions::ActionView::FormHelper }
  end
  
  def self.form_helper_instance
    form_helper_class.new
  end
  
  # FormBuilderClass
  # ----------------
  def self.form_builder_class
    Class.new { include IQ::Upload::Extensions::ActionView::FormBuilder }
  end
  
  def self.form_builder_instance
    form_builder_class.new
  end
    
  private
  
  def self.build_active_record_class(classified)
    Object.__send__(:remove_const, classified) if Object.const_defined?(classified)
    Object.const_set(classified, Class.new(ActiveRecord::Base))
  end
end

# Assertions and helper methods
class Test::Unit::TestCase
  def flunk(text = nil)
    print "\033[0;33mP\033[0m"
  end
  
  def teardown
    FileUtils.rm_r File.join(RAILS_ROOT, 'tmp'),    :force => true
    FileUtils.rm_r File.join(RAILS_ROOT, 'public'), :force => true
  end
  
  def self.fixture_path
    File.expand_path(File.dirname(__FILE__))
  end
  
  protected
  
  def fixture_string_io_upload(path, content_type)
    file = fixture_file_upload(path, content_type)
    string_io = StringIO.new(file.read)
    (class << string_io; self; end).class_eval do
      define_method(:original_filename) { file.original_filename }
      define_method(:content_type)      { file.content_type }
    end
    return string_io
  end
end