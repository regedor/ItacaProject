module IQ::Storage::Adapters
  # Base class for Storage Adapters.
  # Storage Adapters determine how/where uploaded files are stored e.g. local file system, database, s3
  class Base
    attr_reader :options
    
    def initialize(options = {})
      raise ArgumentError, 'You must provide options as a hash' unless options.is_a?(Hash)
      options = default_options.merge(options)
      options.assert_valid_keys(self.valid_options)
      unless self.required_options.all? { |option| options.keys.include?(option) }
        raise ArgumentError, "#{self.required_options.map(&:inspect).to_sentence} are required options" 
      end
      @options = options
    end

    # Should copy the file at <tt>local_path</tt> to <tt>storage_path</tt> on storage medium for later retrieval
    def store(local_path, storage_path)
      raise ArgumentError, 'Arguments must be strings' unless local_path.is_a?(String) && storage_path.is_a?(String)
    end

    # Should retrieve file from <tt>storage_path</tt> and save to <tt>local_path</tt>
    def fetch(storage_path, local_path)
      raise ArgumentError, 'Arguments must be strings' unless local_path.is_a?(String) && storage_path.is_a?(String)
    end

    # Should permanently remove the file from the storage medium at <tt>storage_path</tt>
    def erase(storage_path)
      raise ArgumentError, 'Argument must be a string' unless storage_path.is_a?(String)
    end

    # Should return relative path to file
    def relative_path(storage_path)
      raise ArgumentError, 'Argument must be a string' unless storage_path.is_a?(String)
    end
    
    # Should return absolute path to file
    def absolute_path(storage_path)
      raise ArgumentError, 'Argument must be a string' unless storage_path.is_a?(String)
    end    
    
    # Yields a Tempfile with random filename. The Tempfile is automatically
    # deleted at the end of the method call.
    def with_temp_file
      raise ArgumentError, 'A block must be supplied' unless block_given?
      now = Time.now
      yield(tmp = Tempfile.new("#{now.to_i}.#{now.usec}.#{Process.pid}", options[:tempfile_base] || Dir::tmpdir))
    ensure
      tmp.close true if tmp
    end
    
    # Should return a hash of defaults
    def default_options
      {}
    end
    
    # Should return an array of required options as Symbols
    def required_options
      []
    end
    
    # Should return an array of valid options as Symbols
    def valid_options
      [:tempfile_base]
    end
    
  end
end