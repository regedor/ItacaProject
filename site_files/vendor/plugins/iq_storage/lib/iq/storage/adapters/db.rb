module IQ::Storage
  module Adapters # :nodoc:
    # Persists attached files to table called <tt>uploadify_db_files</tt>. There is a rake task provided to create a migration to create this table
    #    rake uploadify:db_files_table_migration
    # ==== Required Columns
    # * uploadify_db_file_id (integer)
    # * content_type (string)
    class Db < Base
#      include IQ::Uploadify::FileHelpers
#      # when included makes sure your model has the required columns - 'uploadify_db_file_id' and 'content_type'
#      #
#      # sets up a belongs to association on your asset model equivalent to
#      #    belongs_to :uploadify_db_file
#      def on_init()
#        raise IQ::Uploadify::Adapters::UploadifyDbFileTableMissingError.new("To use :db storage engine you must have an 'uploadify_db_files' table. Use rake uploadify:db_files_table_migration to create a migration.") unless asset_class.connection.tables.include?('uploadify_db_files')
#        raise IQ::Uploadify::ConfigurationConflictError.new("Using :db storage engine requires your model to have columns 'uploadify_db_file_id' of type integer and content_type of type string.") unless asset_class.column_names.include?('uploadify_db_file_id') and asset_class.column_names.include?('content_type')
#        Object.const_set(:UploadifyDbFile, Class.new(ActiveRecord::Base)) unless Object.const_defined?(:UploadifyDbFile)
#        asset_class.belongs_to :uploadify_db_file, :class_name => '::UploadifyDbFile', :foreign_key => 'uploadify_db_file_id'
#      end
#
#      # writes asset data to db_file - and sets 'uploadify_db_file_id' appropriately on asset model
#      def store(model_instance)
#        db_file = model_instance.uploadify_db_file || UploadifyDbFile.new
#        db_file.data = model_instance.temp_data
#        db_file.save!
#        model_instance.uploadify_db_file_id = db_file.id
#        model_instance.uploadify_db_file = db_file
#        model_instance.class.update_all ['uploadify_db_file_id = ?', model_instance.uploadify_db_file_id], ['id = ?', model_instance.id]
#      end
#
#      # destroys asset db file record
#      def erase(model_instance)
#        model_instance.uploadify_db_file.destroy unless model_instance.uploadify_db_file.nil?
#      end
#
#      # path is not a supported operation and will raise an Error
#      def path(*args)
#        raise IQ::Uploadify::Exceptions::AbstractMethodError.new("This asset is backed by :db storage engine. The file doesn't have a path on disk - and you'll need to serve it using a controller.")
#      end
#
#      # returns a Tempfile with the assets db file data as its contents.
#      def fetch(model_instance)
#        write_to_temp_file(model_instance.uploadify_db_file.data)
#      end
    end
  end
end