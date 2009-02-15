# A basic abstraction layer for creating blocks
# of text with images - currently using RMagick.
#
# Author::    Andrew Montgomery  (mailto:andy@soniciq.com)
# Copyright:: Copyright (c) 2006 SonicIQ Limited
# License::   Closed source, in-house use only

class IQ::Image::TextGraphic < IQ::Image::TextGraphicBase
  
  attr_reader :width, :height
  
  MY_OPTIONS = [ :line_spacing, :alignment ]
  
  def initialize(text, options = {}, styles = {})
    # Process the arguments
    @text = text.to_s
    @options = options.symbolize_keys!

    # Setup defaults
    @options[:bgcolor]      ||= 'transparent'
    @options[:line_spacing] ||= 0.5

    # raise an error on invalid options
    validate_options(@options)

    # Add style processing rules
    expand_styles(styles)
  
    # Create TextBlocks
    parsed_html = parse_html(text)
    
    # Build the canvas
    build_canvas(parsed_html)
    
    # returns self
    self
  end
  
  def canvas
    @canvas
  end
  
  private
  
  def expand_styles(styles)
    @styles = {}
    styles.each do |k,v|
      k.to_a.each { |key| @styles[key.to_sym] = v }
    end
    @styles
  end
  
  def style_processor(tags)
    unless tags.nil? or tags.empty?
      ret = @styles[tags.join(' ').to_sym]
      tags.each do |x|
        if ret.nil?
          ret = @styles[x.to_sym].dup
        else
          ret.merge!(@styles[x.to_sym])
        end
      end
      ret ||= @styles[tags.last.to_sym]
    end
    ret ||= {} if ret.nil?
    ret = (@options.reject { |k,v| MY_OPTIONS.include?(k) }).merge(ret).delete_if { |k,v| MY_OPTIONS.include? k.to_sym }
  end
  
  def validate_options(options)
    # raise an error on invalid options
    unless options == {}
      raise(ArgumentError, "Invalid options passed, only #{(VALID_OPTIONS + MY_OPTIONS).inspect} are valid") if options.keys.any? { |k| not (VALID_OPTIONS + MY_OPTIONS).include?(k) }
    end
  end
  
  # Build canvas
  # Do lots of funky calculations
  # with baselines and what not
  # to make a nice block of text
  # into a canvas
  def build_canvas(lines_of_text_blocks)
    # Grab the greatest values for each line
    line_baseline   = []
    line_height     = []
    line_width      = []
    lines_of_text_blocks.each_index do |i|
      baselines = (lines_of_text_blocks[i].sort { |a,b| a.baseline <=> b.baseline })
      heights   = (lines_of_text_blocks[i].sort { |a,b| a.height   <=> b.height   })
      line_baseline << baselines.last.baseline
      line_height   << heights.last.height - heights.last.line_spacing
      width = 0
      lines_of_text_blocks[i].each { |l| width += l.width }
      line_width << width
    end
    
    # set up canvas height and width
    @width  = line_width.sort.last
    height = 0
    line_spacing_height = 0
    line_height.each { |h| height += h ; line_spacing_height += (h * (@options[:line_spacing] || 0)) }
    line_spacing_height -= (line_height.last * (@options[:line_spacing] || 0))
    @height = height + line_spacing_height
    
    options = nil
    if @options[:matte]
      options = @options.dup
      options[:bgcolor] = 'transparent'
    else
      options = @options
    end
    
    @canvas = IQ::Image::Canvas.new(@width, @height, options)
    
    # actually go through the lines and do stuff with them to make the canvas
    # for each line align each text block with the baseline
    top = 0
    lines_of_text_blocks.each_index do |i|
      left = 0
      lines_of_text_blocks[i].each do |text_block|
        offset = (line_baseline[i] - text_block.baseline)
        @canvas.overlay!(text_block.to_canvas, :dest_x => left, :dest_y => top + offset)
        left += text_block.width
      end
      top += line_height[i] + ((@options[:line_spacing] || 0) * line_height[i])
    end
    @canvas
  end
  
  # Turns HTML into an array of hashes of format:
  # { :style => :bold, :text => 'the text content' }
  #
  def parse_html(html_lines)
    # do old version, remove when this function actually works
    #old_parse_html(html)

    lines = []
    
    tag_stack = []

    html_lines.gsub(/\<br\ *\/\>/,"\n").each_line do |html|
      
      # Tokenise the HTML input
      tokeniser = HTML::Tokenizer.new(html)

      text_blocks = []

      # For each token ...
      while token = tokeniser.next
        # Grab the HTML node
        node = HTML::Node.parse(nil,0,0,token,false)
        case node
          # if it's a tag ...
          when HTML::Tag
            unless node.closing == :close
              tag_stack.push node.name.downcase.to_sym
            else
              tag_stack.pop
            end
          
          # if it's text
          when HTML::Text
            text_blocks << IQ::Image::TextBlockGraphic.new(CGI::unescapeHTML(node.content), style_processor(tag_stack)) unless node.content.nil? or node.content.sub("\n",'').empty?
        end
      end
      
      lines << text_blocks
      
    end
    lines
  end
    
end