require File.join(File.dirname(__FILE__), 'test_helper')

config = YAML::load(IO.read(RAILS_ROOT + '/db/database.yml'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])
load(RAILS_ROOT + "/db/schema.rb")

class FunctionalTests < Test::Unit::TestCase
  def test_should_perform_basic_upload

  end
end