# A basic abstraction layer for drawing text
# as images manipulation currently using RMagick.
#
# Author::    Andrew Montgomery  (mailto:andy@soniciq.com)
# Copyright:: Copyright (c) 2006 SonicIQ Limited
# License::   Closed source, in-house use only

class IQ::Image::TextBlockGraphic < IQ::Image::TextGraphicBase

  attr_reader :text, :font, :size, :style, :width, :height, :baseline, :line_spacing
  attr_accessor :color, :bgcolor, :matte


  # Create a new text block graphic
  #
  # Params:
  # * <tt>text</tt>: required, text to be turned into a graphic
  # * <tt>options</tt>: option hash
  # Options:
  # * <tt>:bgcolor</tt>: background of text
  # * <tt>:resample</tt>: resampling rate (ie, 2 = 2x scaled then halved)
  # * <tt>:font</tt>: font to use for text
  # * <tt>:size</tt>: size of font to use for text
  # * <tt>:color</tt>: color of font to use for text ('#fff', 'white')
  # * <tt>:style</tt>: style of font to use for text (:bold, :italic, :oblique)
  # * <tt>:matte</tt>: do matte transparency? (:matte => true)
  def initialize(text, options = {})
    # Process the arguments
    @text = text.to_s.sub("\n",'')
    options[:bgcolor] ||= 'transparent'

    options.symbolize_keys!
    
    # grab resample value
    @scale = options[:resample] || 1
    options.delete(:resample)
    
    # raise an error on invalid options
    raise ArgumentError, "Invalid options passed, only #{VALID_OPTIONS.inspect} are valid" if options.keys.any? { |k| not VALID_OPTIONS.include?(k) }

    # Set each bit up
    (VALID_OPTIONS.each { |o| self.send("#{o}=", options[o]) if options[o] }) if options

    # Work out the metrics
    build_renderer    
    self
  end
  
  def text=(string)
    @text = string.to_s
    build_renderer
    @text
  end
  
  def font=(string)
    @font = string.to_s
    build_renderer
    @font
  end
  
  def size=(num)
    @size = num.to_f
    build_renderer
    @size
  end

  def style=(string)
    @style = string.to_s.downcase.to_sym if STYLE_TAG.has_value?(string.to_s.downcase.to_sym)
    build_renderer
    @style
  end

  def to_canvas
    @canvas = IQ::Image::Canvas.new(@width*@scale, @height*@scale, { :bgcolor => @bgcolor })
    @canvas.render_text!(@text, { :size => (@size ? @size*@scale : 12 * @scale), :font => @font, :color => @color, :style => @style, :y_offset => @line_spacing, :matte => @matte })
    @canvas.resize!(@width, @height)
  end
  
  private
  
  def build_renderer
    # Now actually draw the text!
    renderer = Magick::Draw.new
    renderer.font = @font if @font
    renderer.pointsize = @size if @size
    
    # Hash for mapping our types to magick types
    font_style = { :normal => Magick::NormalStyle, :italic => Magick::ItalicStyle, :oblique => Magick::ObliqueStyle }
    font_weight = { :bold => Magick::BoldWeight }
    
    renderer.font_style = font_style[@style] if @style and font_style.has_key?(@style.to_sym)
    renderer.font_weight = font_weight[@style] if @style and font_weight.has_key?(@style.to_sym)
    
    metrics = renderer.get_type_metrics(@text)
    @line_spacing, @baseline, @width, @height = metrics.descent.abs, (-metrics.descent - metrics.height).abs, metrics.width, metrics.height
  end
  
end
