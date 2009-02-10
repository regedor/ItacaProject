require File.join(File.dirname(__FILE__), 'test_helper')

config = YAML::load(IO.read(RAILS_ROOT + '/db/database.yml'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])
load(RAILS_ROOT + "/db/schema.rb")

class FunctionalTests < Test::Unit::TestCase
  def test_should_perform_basic_upload
    klass = Factory.uploadified_basic_asset_class
    instance = klass.new(:uploaded_data => fixture_file_upload('/files/simple.txt', 'text/plain'))
    instance.save!
    assert instance = klass.find(:first), 'Should have a new record in db'
    assert_equal 'simple.txt', instance.filename
    segmented_dir = File.join(("%08d" % instance.id.to_s).scan(/..../))
    assert File.exists?(File.join(RAILS_ROOT, 'public', 'assets', 'basic_assets', segmented_dir, 'simple.txt'))
  end
  
  def test_should_use_newly_uploaded_data_when_record_updated
    klass = Factory.uploadified_basic_asset_class
    instance = klass.new(:uploaded_data => fixture_file_upload('/files/simple.txt', 'text/plain'))
    instance.save!
    instance.uploaded_data = fixture_file_upload('/files/another_simple.txt', 'text/plain')
    instance.save!
    assert_equal 'another_simple.txt', instance.filename
    segmented_dir = File.join(("%08d" % instance.id.to_s).scan(/..../))
    assert File.exists?(File.join(RAILS_ROOT, 'public', 'assets', 'basic_assets', segmented_dir, 'another_simple.txt'))
  end
end