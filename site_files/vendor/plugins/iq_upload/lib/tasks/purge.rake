namespace :iq do
  namespace :upload do
    desc 'Clear all auto generated files and database entries'
    task :purge_versions => :environment do
      # Get Rails to load the models
      Dir.glob(File.join(RAILS_ROOT, 'app/models/**/*.rb')).each do |file|
        File.basename(file, '.rb').classify.constantize
      end

      # Delete versions for each class with IQ::Upload::Base (using destroy so that image files get deleted)
      IQ::Upload::Base.included_in_classes.each { |model_class| model_class.destroy_all('base_version_id IS NOT NULL') }
      
      # TODO: ideally would do the following if there were an easy way to determing the versions dir
      # model_class.delete_all('base_version_id IS NOT NULL')
      # if File.exists?(path = File.join(Rails.public_path, 'assets', folder))
      #   FileUtils.rm_rf path
      # end
    end
  end
end