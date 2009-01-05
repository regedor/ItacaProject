# Path to root of plugin dir
plugin_root = File.join(File.dirname(__FILE__), '../../../')
$:.unshift(plugin_root + 'lib')

# Use vendor rails if possible
if File.directory?(rails_dir = File.join(plugin_root, '../../rails'))
  $:.unshift File.join(rails_dir, 'activerecord/lib')
  $:.unshift File.join(rails_dir, 'actionpack/lib')
  $:.unshift File.join(rails_dir, 'activesupport/lib')
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

# Require the plugin and init file
require 'iq/helper'
require File.join(File.dirname(__FILE__), '../../../init')

# Stop annoying depreciation warnings in test output
Object.send(:undef_method, :id) if Object.respond_to?(:id)
Object.send(:undef_method, :type) if Object.respond_to?(:type)

class Post
  attr_accessor :title
end

class FormHelperTester
  attr_reader :post

  cattr_accessor :request_forgery_protection_token

  def initialize
    @post = Post.new
  end
  
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionController::RecordIdentifier
  include ActionController::PolymorphicRoutes
  include ActionController::Helpers
  include ActionController::RequestForgeryProtection
  include IQ::Helper::FormHelper
end

module Factory
  extend Mocha::AutoVerify
  
  def self.form_builder(options = {})
    options = {
      :object_name => 'an_instance',
      :object => mock(),
      :template => view_instance,
      :options => {},
      :proc => Proc.new {}
    }.merge(options)
    
    IQ::Helper::FormBuilder.new(
      options[:object_name], options[:object], options[:template], options[:options], options[:proc]
    )
  end
  
  def self.view_instance
    ActionView::Base.new
  end
end

class Test::Unit::TestCase
  
  private
  
  # Note: it is ok to lazy initialize non state-changing objects
  # or objects that we will never require multiple instances of.
  def view_instance
    @view_instance ||= Factory.view_instance
  end
end
