# An instance of this class is yielded as the block parameter to
# BaseHander#response_for and is used to keep a record of response formats
# along with their procs in an array of key/value pairs where the key is the
# format name and the proc is the block given to the format method.
# 
# Example:
#   response = ResponseHandler.new
#   response.html { render :action => 'edit }
#   response.js { render :text => 'my.javascript();' }
#   response.xml
#   response.formats #=> [[:html, #<Proc>], [:js, #<Proc>]]
# 
# Note: in the case of the 'xml' call above, no block is given. In this case
# an empty proc is used.
class IQ::Crud::ResponseHandler
  # Returns an array of [:format, #<Proc>] pairs.
  attr_reader :formats
  
  # Returns a new ResponseHandler with it's formats set to an empty Array.
  def initialize
    @formats = []
  end
  
  # Records [:format, #<Proc>] in formats array.
  def method_missing(format, *args, &block)
    raise ArgumentError, ":#{format} format already set" if formats.any? { |name, proc| name.eql?(format) }
    raise ArgumentError, 'Must not supply both argument and block' if !args.empty? && block_given?
    if !args.empty? && (!args.first.nil? || args.size > 1)
      raise ArgumentError, 'The only argument accepted is nil for disabling formats'
    end
    formats << [format, block || (args.empty? ? proc {} : nil)]
  end
end