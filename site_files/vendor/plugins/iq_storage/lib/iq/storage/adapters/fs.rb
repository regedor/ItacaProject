module IQ::Storage
  module Adapters # :nodoc:
    # A base path for file storage can be specified via :absolute_base option in the initializer
    class Fs < Base
    
      # Copies file from <tt>local_path</tt> to <tt>storage_path</tt> (relative to :absolute_base option when set) on
      # file system, creating directory and setting correct permissions
      def store(local_path, storage_path)
        super
        full_path = absolute_path(storage_path)
        FileUtils.mkdir_p(File.dirname(full_path), :mode => 0755)
        FileUtils.cp(local_path, full_path)
        File.chmod(0644, full_path)
      end

      # Returns a Tempfile with the assets file data as its contents.
      def fetch(storage_path, local_path)
        super
        FileUtils.cp absolute_path(storage_path), local_path
      end
      
      # Deletes the asset file from file system storage 
      def erase(storage_path)
        super
        file = absolute_path(storage_path)
        FileUtils.rm file if File.exists?(file)

        dir = File.dirname(file)
        while File.expand_path(parent = File.dirname(dir)).size > File.expand_path(options[:absolute_base] || '.').size
          FileUtils.rm_rf(dir) if File.exists?(dir) && directory_empty?(dir)
          dir = parent
        end
        FileUtils.rm_rf(dir) if File.exists?(dir) && directory_empty?(dir)
      end

      # Returns path relative to :relative_base option. When :relative_base option is not set, :absolute_base option
      # is used, failing that, current directory is assumed.
      # 
      # Raises Exceptions::OutsideBaseDirectoryError when storage path resolves outside of :relative_base or
      # :absolute_base option.
      def relative_path(storage_path)
        full_path = absolute_path(storage_path)
        relative_base = options[:relative_base] || options[:absolute_base] || File.expand_path('.')
        raise(
          Exceptions::OutsideBaseDirectoryError, "Storage path: #{storage_path} leads out of base: #{relative_base}"
        ) unless full_path.starts_with?(File.expand_path(relative_base))
        full_path.sub(/^#{File.expand_path(relative_base)}\//, '')
      end

      # Returns absolute path to <tt>storage_path</tt> on file system.
      # 
      # Raises Exceptions::OutsideBaseDirectoryError when storage path resolves outside of :absolute_base option.
      def absolute_path(storage_path)
        super
        return File.expand_path(storage_path) if (absolute_base = options[:absolute_base]).nil?
        full_path = File.expand_path(
          storage_path.starts_with?('/') ? storage_path : File.join(absolute_base, storage_path)
        )
        unless full_path.starts_with?(File.expand_path(absolute_base))
          raise(
            Exceptions::OutsideBaseDirectoryError, "Storage path: #{storage_path} leads out of base: #{absolute_base}"
          )
        end
        full_path
      end

      # Returns Hash of default options for fs strorage
      def default_options
        {}
      end
      
      # Returns an Array of required options as Symbols
      def required_options
        []
      end

      # Returns an Array of valid options as Symbols
      def valid_options
        @valid_options ||= super + [:absolute_base, :relative_base]
      end
      
      private
      
      def directory_empty?(dir_path)
        (Dir.entries(dir_path) - ['.', '..', '.svn', '.DS_Store']).empty?
      end
      
      module Exceptions # :nodoc:
        class OutsideBaseDirectoryError < StandardError; end
      end
    end
  end
end