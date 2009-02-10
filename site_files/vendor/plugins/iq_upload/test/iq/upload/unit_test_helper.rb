require File.join(File.dirname(__FILE__), 'test_helper')
require 'mocha'

# Disconnect from the database
require "unit_record"
ActiveRecord::Base.disconnect!
ActiveRecord::Base.instance_eval do
  def table_exists?() true end

  def reflect_on_callback(callback)
    self.read_inheritable_attribute(callback) || []
  end
end