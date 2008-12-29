class IQ::Crud::BaseHandler
  # Returns Hash containing format pairs for a given action.
  attr_reader :responses
  
  def initialize
    @responses = {}
  end
  
  # Sets respond_to blocks for given actions. If only the html format needs
  # setting, then the block parameter can be omitted and the block will be
  # given as the html respond_to.
  # 
  # Examples:
  #   response_for :new, :edit do |format|
  #     format.html
  #     format.css do
  #       render :layout => false
  #     end
  #   end
  #
  #   # Note: any formats will be merged with defaults i.e. the following will
  #   # add a css format, leaving html and xml intact.
  #   response_for :new, :edit do |format|
  #     format.css do
  #       render :layout => false
  #     end
  #   end
  # 
  #   # When only replace html output proc
  #   response_for :index, :show do
  #     render :layout => 'special'
  #   end
  # 
  #   # Disable default format responses and set a new one
  #   response_for :index, :show do |format|
  #     format.html nil
  #     format.xml nil
  #     format.atom { render_atom_feed }
  #   end
  # 
  def response_for(*actions, &block)
    raise ArgumentError, 'A block is mandatory for this method' unless block_given?
    raise ArgumentError, 'Actions must be supplied as Symbols' if actions.any? { |action| !action.is_a?(Symbol) }

    return response_for(*actions) { |format| format.html(&block) } if block.arity < 1
    response = IQ::Crud::ResponseHandler.new
    block.call response
    actions.each do |action|
      if responses = self.responses[action]
        response.formats.each do |name, proc|
          existing_pair = responses.find { |key, val| key == name }
          if proc.nil?
            responses.delete(existing_pair)
          else
            existing_pair ? existing_pair[1] = proc : responses << [name, proc]
          end
        end
      else
        self.responses[action] = response.formats
      end
    end
  end
  
  private
  
  attr_writer :responses
end