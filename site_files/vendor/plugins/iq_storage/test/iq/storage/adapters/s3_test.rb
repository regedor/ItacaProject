require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Definition
# -----------------------------------------------------------------------------------------------
class IQ::Storage::Adapters::S3::ClassDefinitionTest < Test::Unit::TestCase
  def test_should_inherit_remote_base_storage_adapter
    assert_equal IQ::Storage::Adapters::RemoteBase, IQ::Storage::Adapters::S3.superclass
  end
end

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

