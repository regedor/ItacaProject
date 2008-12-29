# Path to root of plugin dir
plugin_root = File.join(File.dirname(__FILE__), '../../../')
$:.unshift(plugin_root + 'lib')

# Use vendor rails if possible
if File.directory?(rails_dir = File.join(plugin_root, '../../rails'))
  $:.unshift File.join(rails_dir, 'activerecord/lib')
  $:.unshift File.join(rails_dir, 'actionpack/lib')
  $:.unshift File.join(rails_dir, 'activesupport/lib')
  $:.unshift File.join(rails_dir, 'actionmailer/lib')
end

# Bits used for testing
require 'test/unit'
require 'rubygems'
require 'mocha'
require 'redgreen'

# Parts of rails used
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_controller/test_process'
require 'action_view'
require 'action_mailer'

# Require the plugin and init file
require 'iq/crud'
require File.join(File.dirname(__FILE__), '../../../init')

# Require plugin dependencies
$:.unshift File.join(plugin_root, '../iq_view_path_extensions/lib')
require File.join(plugin_root, '../iq_view_path_extensions/init')

$:.unshift File.join(plugin_root, '../iq_helper/lib')
require File.join(plugin_root, '../iq_helper/init')

# Stop annoying depreciation warnings in test output
Object.send(:undef_method, :id) if Object.respond_to?(:id)
Object.send(:undef_method, :type) if Object.respond_to?(:type)

RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

module Factory
  # ResponseHandler
  # ---------------
  def self.response_handler_class
    IQ::Crud::ResponseHandler
  end
  
  def self.response_handler_instance
    response_handler_class.new
  end
  
  # BaseHandler
  # -----------
  def self.base_handler_class
    IQ::Crud::BaseHandler
  end
  
  def self.base_handler_instance
    base_handler_class.new
  end
  
  # Build Class
  # -----------
  def self.with_temp_class(name, base_class = Object)
    raise ArgumentError, 'Must supply a block' unless block_given?
    Object.const_set(name, Class.new(base_class))
    yield Object.const_get(name)
    Object.__send__(:remove_const, name) if Object.const_defined?(name)
  end
end

# Test Classes
class ShinyProduct
  class << self
    include Mocha::AutoVerify
  end
  
  def self.content_columns
    [
      stub(:name => 'name',       :human_name => 'Name',        :limit => 20, :type => :string),
      stub(:name => 'brand_name', :human_name => 'Brand name',  :limit => 25, :type => :string)
    ]
  end
  
  attr_accessor :id, :name, :brand_name
  
  def initialize(assigns = {})
    assigns.each { |k, v| send("#{k}=", v) } unless assigns.blank?
  end

  def to_param
    id.to_s
  end
  
  def attributes=(assigns)
    assigns.each { |k, v| send("#{k}=", v) } unless assigns.blank?
  end
  
  def update_attributes(attributes)
    self.attributes = attributes
    save
  end
  
  def column_for_attribute(attribute)
    self.class.content_columns.find { |k, v| k.name.to_s == attribute }
  end
end

class AnotherProduct
end

class Test::Unit::TestCase
  def flunk(text = nil)
    print "\033[0;33mP\033[0m"
  end
  
  private
  
  def assert_protected(instance, method)
    assert(instance.protected_methods.include?(method.to_s), "'#{method}' should be protected")
  end
  
  def crudified_instance(*args)
    @crudified_instance ||= begin
      controller_class.crudify(*args)
      controller_class.new
    end
  end
  
  def admin_crudified_instance(*args)
    @admin_crudified_instance ||= begin
      admin_controller_class.crudify(*args)
      admin_controller_class.new
    end
  end
  
  def crudified_view
    @crudified_view ||= begin
      view = ActionView::Base.new([], nil, crudified_instance)
      # Make the crudify helpers available
      ActionView::Base.send :include, controller_class.master_helper_module
      view
    end
  end
  
  def admin_crudified_view
    @admin_crudified_view ||= begin
      view = ActionView::Base.new([], nil, admin_crudified_instance)
      # Make the crudify helpers available
      ActionView::Base.send :include, admin_controller_class.master_helper_module
      view
    end
  end
  
  def controller_class
    @controller_class ||= begin
      classified = 'ShinyProductsController'
      Object.__send__(:remove_const, classified) if Object.const_defined?(classified)
      Object.const_set(classified, Class.new(ActionController::Base))
      ShinyProductsController.class_eval do
        def dummy
          render :nothing => true
        end
        
        # Re-raise errors caught by the controller.
        def rescue_action(e) raise e end
      end
      ShinyProductsController
    end
  end
  
  def admin_controller_class
    @admin_controller_class ||= begin
      Object.const_set('Admin', Module.new) unless Object.const_defined?('Admin')
      classified = 'ShinyProductsController'
      Admin.__send__(:remove_const, classified) if Admin.const_defined?(classified)
      Admin.const_set(classified, Class.new(ActionController::Base))
      Admin::ShinyProductsController.class_eval do
        def dummy
          render :nothing => true
        end
        
        # Re-raise errors caught by the controller.
        def rescue_action(e) raise e end
      end
      Admin::ShinyProductsController
    end
  end
  
  def model_class
    ShinyProduct
  end
  
  def valid_member
    @valid_member ||= model_class.new(:id => 21, :name => 'Foo', :brand_name => 'Foo & Bar Inc.')
  end
  
  def blank_member
    @blank_member ||= begin
      member = model_class.new
      member.stubs(:new_record?).returns(true)
      member
    end
  end
  
  def valid_collection
    @valid_collection ||= [ 
      model_class.new(:id => 21, :name => 'Foo',        :brand_name => 'Footech'), 
      model_class.new(:id => 35, :name => 'Bar',        :brand_name => ''), 
      model_class.new(:id => 46, :name => 'Yum & Baz',  :brand_name => 'YumBaz Inc.')
    ]
  end
  
  def with_shiny_products_route
    with_routing do |set|
      set.draw do |map|
        map.resources :shiny_products, :member => { :delete => :get }, :collection => { :dummy => :get }
      end
      yield
    end
  end
  
  def with_admin_shiny_products_route
    with_routing do |set|
      set.draw do |map|
        map.namespace :admin do |ns|
          ns.resources :shiny_products, :member => { :delete => :get }, :collection => { :dummy => :get }
        end
      end
      yield
    end
  end
  
  def request_with_shiny_products_route(method, action, *args)
    @controller = crudified_instance
    @request    ||= ActionController::TestRequest.new
    @response   ||= ActionController::TestResponse.new
    
    with_shiny_products_route do
      send(method, action, *args)
      yield if block_given?
    end
  end
  
  def request_with_admin_shiny_products_route(method, action, *args)
    @controller = admin_crudified_instance
    @request    ||= ActionController::TestRequest.new
    @response   ||= ActionController::TestResponse.new
    
    with_admin_shiny_products_route do
      send(method, action, *args)
      yield if block_given?
    end
  end
  
  def with_dummy_request
    request_with_shiny_products_route(:get, :dummy) do
      yield
    end
  end
  
  def with_admin_dummy_request
    request_with_admin_shiny_products_route(:get, :dummy) do
      yield
    end
  end
  
  def request_with_both_shiny_product_routes(method, action, *args)
    ['', 'admin_'].each do |prefix|
      send("request_with_#{prefix}shiny_products_route", method, action, *args) do
        yield prefix if block_given?
      end
    end
  end
  
  def setup_xml_request_header
    @request = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = Mime::XML.to_s
  end
end