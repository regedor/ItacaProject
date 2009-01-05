module IQ::ViewPathExtensions::ActionView::TemplateFinder
  def self.included(base) # :nodoc:
    base.send :alias_method_chain, :pick_template,    :exclude_controller_path
    base.send :alias_method_chain, :template_exists?, :exclude_controller_path

    base.module_eval <<-EOF
    def find_base_path_for_with_exclude_controller_path(template_file_name) 
      @view_paths.find do |path|
        @@processed_view_paths[path].include?(apply_controller_path_exclusion(path, template_file_name))
      end
    end
    alias_method_chain :find_base_path_for, :exclude_controller_path
    
    def find_template_extension_from_handler_with_exclude_controller_path(template_path, template_format = @template.template_format)
      formatted_template_path = "\#{template_path}.\#{template_format}"

      view_paths.each do |path|
        if (extensions = @@file_extension_cache[path][apply_controller_path_exclusion(path, formatted_template_path)]).any?
          return "\#{@template.template_format}.\#{extensions.first}"
        elsif (extensions = @@file_extension_cache[path][apply_controller_path_exclusion(path, template_path)]).any?
          return extensions.first.to_s
        end
      end
      nil
    end
    alias_method_chain :find_template_extension_from_handler, :exclude_controller_path
EOF
  end

  def pick_template_with_exclude_controller_path(template_path, extension)
    file_name = "#{template_path}.#{extension}"
    base_path = find_base_path_for(file_name)
    base_path.blank? ? false : "#{base_path}/#{apply_controller_path_exclusion(base_path, file_name)}"
  end

  alias_method :template_exists_with_exclude_controller_path?, :pick_template_with_exclude_controller_path
  
  def apply_controller_path_exclusion(path, file_name)
    if @template.controller.class.exclude_controller_path_for?(path)
      file_name.sub(/^#{@template.controller.controller_path}\//, '')
    else
      file_name
    end
  end
end