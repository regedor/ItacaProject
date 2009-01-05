module IQ::ViewPathExtensions::ActionMailer
  def self.included(base)
    class << base            
      def exclude_controller_path_for?(path)
        false
      end
    end
  end
end