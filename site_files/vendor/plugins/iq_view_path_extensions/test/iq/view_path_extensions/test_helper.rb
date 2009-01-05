$:.unshift(File.dirname(__FILE__) + '/../../../lib')
require 'test/unit'
require 'rubygems'
require 'redgreen'

rails_dir = File.dirname(__FILE__) + '/../../../../../../vendor/rails'
actionpack_lib_dir = File.directory?(rails_dir) ? ("#{rails_dir}/actionpack/lib/") : ''

require "#{actionpack_lib_dir}action_controller"
require 'actionmailer'
require "#{actionpack_lib_dir}action_view"
require "#{actionpack_lib_dir}action_controller/test_process"

unless ActionController::Base.respond_to?('view_paths')
  raise "Can only test iq_controller_path_extensions with an ActionController::Base that supports view_paths"
end

require 'iq/view_path_extensions'
require File.dirname(__FILE__) + '/../../../init'