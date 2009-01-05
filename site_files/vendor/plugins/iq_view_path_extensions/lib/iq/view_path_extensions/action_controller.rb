module IQ::ViewPathExtensions::ActionController
  def self.included(base)
    class << base
      # Keep a record of which controllers have an :exclude_controller_path option.
      # This will be a hash where the controller names are the keys which contain
      # arrays of paths that should have controller_path exlusion applied.
      
      @@excluded_controller_paths = {}
      
      def excluded_controller_paths=(paths)
        @@excluded_controller_paths[name] = paths
      end
      
      def excluded_controller_paths
        if paths = @@excluded_controller_paths[name]
          paths
        else
          if superclass.respond_to?(:excluded_controller_paths)
            superclass.excluded_controller_paths.dup.freeze
          else
            @@excluded_controller_paths[name] = []
          end
        end
      end
        
      def exclude_controller_path_for?(path)
        excluded_controller_paths.include?(path)
      end

      # Adds :exclude_controller_path option
      def prepend_view_path_with_view_path_extentions(path, options = {})
        if options[:exclude_controller_path] == true
          self.excluded_controller_paths = excluded_controller_paths.dup if excluded_controller_paths.frozen?
          excluded_controller_paths.unshift(path)
        end
        prepend_view_path_without_view_path_extentions(path)
      end
      alias_method_chain :prepend_view_path, :view_path_extentions

      # Adds :exclude_controller_path option
      def append_view_path_with_view_path_extentions(path, options = {})
        if options[:exclude_controller_path] == true
          self.excluded_controller_paths = excluded_controller_paths.dup if excluded_controller_paths.frozen?
          excluded_controller_paths << path
        end
        append_view_path_without_view_path_extentions(path)
      end
      alias_method_chain :append_view_path, :view_path_extentions
    end
  end
end