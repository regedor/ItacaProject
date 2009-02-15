# A basic abstraction layer for common image
# manipulation currently using RMagick.
#
# Author::    James Hill  (mailto:jamie@soniciq.com)
# Copyright:: Copyright (c) 2006 SonicIQ Limited
# License::   Closed source, in-house use only

class IQ::Image::Canvas
  # The image resource
  attr_reader :resource # :nodoc:
  # Only accessible to Canvas objects
  protected :resource

  # Alias <tt>self.new</tt> as <tt>self.new_canvas</tt> allowing for <tt>self.new</tt>
  # to be overridden.
  #
  # Note that <tt>self.new</tt> (when called with params) calls initialize, but now 
  # <tt>self.new_canvas</tt> calls initialize meaning we can override <tt>self.new</tt>,
  # this creates the ultimate Adaptor. Could have just used <tt>private_class_method :new</tt>
  # and defined <tt>self.create</tt> instead but this way we get to use <tt>Canvas.new</tt>.
  class << self
    alias :new_canvas :new
    private :new_canvas
  end

  # Create a new canvas object with given resource.
  # 
  # returns new Canvas object
  def initialize(resource) # :nodoc:
    @resource = resource
    self
  end
  
  # Create a new canvas at given size.
  # 
  # returns new Canvas object
  def self.new(width, height, options = {})
    options.symbolize_keys!
    options[:bgcolor] ||= '#fff'
    resource = Magick::Image.new(width, height) {
      self.background_color = options[:bgcolor]
    }
    resource.matte = true
    return nil unless resource
    new_canvas(resource)
  end
  
  # Read in image file.
  # 
  # returns Canvas, or nil if unsuccessful 
  def self.read(filename)
    begin
      # Note: the File.read with from_blob is to get around the need for file
      # extensions.
      resource = Magick::Image.from_blob(File.read(filename)).first
    rescue
      raise IQ::Image::Canvas::Exceptions::ReadError, "Could not read image file at '#{filename}'"
    end
    new_canvas(resource)
  end
  
  # Ping an image file to retrieve it's meta data.
  # 
  # returns Canvas, or nil if unsuccessful 
  def self.ping(filename)
    begin
      resource = Magick::Image.ping(filename).first
    rescue
      raise IQ::Image::Canvas::Exceptions::ReadError, "Could not read image file at '#{filename}'"
    end
    new_canvas(resource)
  end
  
  module Exceptions
    class ReadError < StandardError; end
  end
  
  # Writes the image to the specified file, if no image
  # format is supplied, it is determined from the extension.
  # 
  # Options:
  # * <tt>:format</tt> - format of image e.g. <tt>'jpg'</tt>, <tt>'png'</tt> etc.
  # * <tt>:quality</tt> - quality percentage for lossy formats (jpeg will be default).
  #
  # returns self, or nil if the image format cannot be determined
  def write(filename, options = {})
    options.symbolize_keys!
    format  = options[:format]  && options[:format].to_s.strip.upcase
    quality = options[:quality] && options[:quality].to_i
    format  = 'JPEG'  if (quality && !format) || format == 'JPG'
    compression = nil
    
    if format == 'JPEG' || File.extname(filename) =~ /jpeg|jpg/i
      quality ||= (!@resource.quality.to_i.zero? && @resource.quality) || 80
      flatten! # TODO: other formats need flattening such as gif, bmp etc.
    elsif format == 'PNG' || File.extname(filename) =~ /png/i
      quality ||= 100
      compression = Magick::ZipCompression
      #@resource = @resource.quantize(2**24)
    end

    @resource.format = format if format
    
    
    success = @resource.write(filename) do
      self.format       = format  if format
      self.quality      = quality if quality      
      self.compression  = compression if compression
    end
    return nil unless success
    self
  end
  
  # TODO: needs DRYing up as it is very similar to 'write' method
  def to_blob(options = {})
    options.symbolize_keys!
    format  = (options[:format]  && options[:format].to_s.strip.upcase) || 'PNG'
    quality = options[:quality] && options[:quality].to_i
    format  = 'JPEG'  if (quality && !format) || format == 'JPG'

    if format == 'JPEG' || File.extname(filename) =~ /jpeg|jpg/i
      quality ||= (!@resource.quality.to_i.zero? && @resource.quality) || 80
      flatten! # TODO: other formats need flattening such as gif, bmp etc.
    elsif format == 'PNG' || File.extname(filename) =~ /png/i
      quality ||= 100
      compression = Magick::ZipCompression
      @resource = @resource.quantize(2**24)
    end
    
    @resource.format = format if format

    @resource.to_blob do
      self.format       = format
      self.quality      = quality if quality
      self.compression  = compression if compression
    end
  end
  
  # Returns width of canvas
  def width
    @resource.columns
  end
  
  # Returns height of canvas
  def height
    @resource.rows
  end
  
  # Returns format of canvas
  def format
    @resource.format.downcase.sub('jpeg', 'jpg')
  end
  
  # Strips an image of all profiles and comments.
  # 
  # returns new Canvas object
  def strip
    self.dup.strip!
  end
  
  # In-place version of strip
  # 
  # returns self
  def strip!
    @resource.strip!
    self
  end
  
  # Resize image to specified size.
  # 
  # returns new Canvas object
  def resize(width, height, options = {})
    self.dup.resize!(width, height, options)
  end
  
  # In-place version of resize
  # 
  # returns self
  def resize!(width, height, options = {})
    raise('Failed to supply width and height') if (width.nil? or height.nil?)
    options.symbolize_keys!
    @resource = @resource.resize(width, height)
    self
  end
  
  # Resize image to specified size maintaining aspect ratio.
  # 
  # Options:
  # * <tt>:padding</tt> - used to determine whether or not to add padding to an
  #   image to reach the desired size.
  # * <tt>:bgcolor</tt> - background color used when padding
  #   e.g. <tt>'##f80'</tt> or <tt>'##ff8800'</tt> (default: <tt>'##fff'</tt>).
  #
  # Option examples:
  #   fit_to 100, 50, :padding # :padding => 'both' or :padding => true do the same
  #   fit_to 100, 50, :padding => 'horizontal', :bgcolor => '#f80'
  #   fit_to 50, 100, :padding => 'vertical'
  # 
  # returns new Canvas object
  def fit_to(width, height, options = {})
    self.dup.fit_to!(width, height, options)
  end
  
  # In-place version of fit_to
  #
  # returns self
  def fit_to!(width, height, options = {})
    raise('Failed to supply width and height') if (width.nil? or height.nil?)
    options.symbolize_keys!
    options[:bgcolor] ||= '#fff'

    # Maintain aspect ratio
    src_ratio  = @resource.columns.to_f / @resource.rows.to_f
    dest_ratio = width.to_f / height.to_f
    if (dest_ratio > src_ratio)
      new_width  = (height * src_ratio).round
      new_height = height
    else
      new_width  = width
      new_height = (width / src_ratio).round
    end

    offset_x = 0
    offset_y = 0
    canvas_width = new_width
    canvas_height = new_height

    case options[:padding]
      when 'horizontal'
        canvas_width = width
        offset_x = (width - new_width) / 2
      when 'vertical'
        canvas_height = height
        offset_y = (height - new_height) / 2
      when 'both', true
        offset_x = (width - new_width) / 2
        offset_y = (height - new_height) / 2
        canvas_width = width
        canvas_height = height
    end

    # Do scaling only if it needs it
    if new_width < @resource.columns or new_height < @resource.rows
      scaled = self.resize(new_width, new_height)
    end

    # Do padding
    unless options[:padding]
      @resource = scaled.resource unless scaled.nil?
    else
      scaled ||= self.dup
      @resource = IQ::Image::Canvas.new(
        canvas_width, canvas_height,
        :bgcolor => options[:bgcolor]
      ).overlay!(scaled, :dest_x => offset_x, :dest_y => offset_y).resource
    end
    self
  end
  
  # Overlay a canvas on self
  # 
  # Options:
  # * <tt>:dest_x</tt> - x offset on self.
  # * <tt>:dest_y</tt> - y offset on self.
  # * <tt>:src_x</tt> - x offset on source canvas.
  # * <tt>:src_y</tt> - y offset on source canvas.
  # * <tt>:width</tt> - width of overlay.
  # * <tt>:height</tt> - height of overlay.
  # 
  # returns new Canvas object
  def overlay(source, options = {})
    self.dup.overlay!(source, options)
  end
  
  # In-place version of overlay
  # 
  # returns self
  def overlay!(source, options = {})
    raise 'A canvas image must be supplied' unless source
    
    options[:dest_x]  ||= 0
    options[:dest_y]  ||= 0
    options[:src_x]   ||= 0
    options[:src_y]   ||= 0
    options[:width]   ||= source.width
    options[:height]  ||= source.height
    options[:opacity] ||= 100
    options[:mode]    ||= :normal

    # Canvas needs resizing
    if options[:width].to_i != source.width or options[:height].to_i != source.height
      source = source.resize(options[:width].to_i, options[:height].to_i)
    end

    source.opacity = options[:opacity] unless options[:opacity] == 100
    
    @resource.composite!(source.resource, options[:dest_x], options[:dest_y],
      case options[:mode].to_sym
        when :normal    : Magick::OverCompositeOp
        when :multiply  : Magick::MultiplyCompositeOp
        when :screen    : Magick::ScreenCompositeOp
        when :mask      : Magick::CopyOpacityCompositeOp
      end
    )
    self
  end
  
  # Drop Shadow a canvas
  # 
  # Options:
  # * <tt>:size</tt>    - size of drop_shadow.
  # * <tt>:offset</tt>  - offset from self.
  # * <tt>:angle</tt>   - angle from self.
  # * <tt>:opacity</tt> - opacity of drop_shadow as a percentage.
  # 
  # returns new Canvas object
  def drop_shadow(options = {})
    self.dup.drop_shadow!(options)
  end
  
  # In-place version of drop_shadow
  # 
  # returns self
  def drop_shadow!(options = {})
    options[:angle]     ||= 135
    options[:size]      ||= 5
    options[:distance]  ||= 5
    options[:opacity]   ||= 50
    
    radians = -options[:angle] * (Math::PI / 180)
    x_offset = -(options[:distance] * Math.cos(radians)).to_i
    y_offset = -(options[:distance] * Math.sin(radians)).to_i

    canvas_x = (x_offset < options[:size] ? -x_offset + options[:size] : 0)
    canvas_y = (y_offset < options[:size] ? -y_offset + options[:size] : 0)
    shadow_x = (x_offset < 0 ? 0 : x_offset)
    shadow_y = (y_offset < 0 ? 0 : y_offset)

    shadow = self.shadow(options)
    canvas = IQ::Image::Canvas.new(shadow.width + x_offset.abs, shadow.height + y_offset.abs, :bgcolor => 'transparent')
    canvas.overlay!(shadow, :dest_x => shadow_x, :dest_y => shadow_y)
    canvas.overlay!(self, :dest_x => canvas_x, :dest_y => canvas_y)
    
    @resource = canvas.resource
    self
  end
  
  
  # Shadow a canvas
  # 
  # Options:
  # * <tt>:size</tt>    - size of shadow.
  # * <tt>:opacity</tt> - opacity of shadow as a percentage.
  # 
  # returns new Canvas object
  def shadow(options = {})
    self.dup.shadow!(options)
  end
  
  # In-place version of shadow
  # 
  # returns self
  def shadow!(options = {})
    options[:size]      ||= 5
    options[:opacity]   ||= 75
    
    @resource = @resource.shadow(0, 0, options[:size].to_f / 2, options[:opacity].to_f / 100)
    self
  end
  
  # Set opatity of Canvas
  # 
  # returns self
  def opacity=(opacity)
    # intercept original alpha channel with pixel intensity
    alpha_channel = @resource.channel(Magick::AlphaChannel).negate
    intensity = (Magick::MaxRGB * (opacity/100.0)).round
    alpha_channel.composite!(Magick::Image.new(width, height) do
      self.background_color = Magick::Pixel.new(intensity,intensity,intensity)
    end, Magick::CenterGravity, Magick::MultiplyCompositeOp)
    alpha_channel.matte = false
    
    @resource.composite!(alpha_channel, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
    self
  end
  
  # Return blurred version of self
  # 
  # Options:
  # * <tt>:radius</tt> - size of blur.
  #
  # returns new Canvas object
  def blur(options = {})
    self.dup.blur!(options)
  end
  
  # In-place version of blur
  # 
  # returns self
  def blur!(options = {})
    options[:radius] ||= 5
    @resource = @resource.gaussian_blur(0, options[:radius])
    self
  end
  
  # Return given Channel of self
  # 
  # returns new Canvas object
  def channel(channel)
    self.dup.channel!(channel)
  end
  
  # In-place version of channel
  # 
  # returns self
  def channel!(channel)
    @resource = @resource.channel(
      case channel.to_sym
        when :red     : Magick::RedChannel
        when :green   : Magick::GreenChannel
        when :blue    : Magick::BlueChannel
        when :cyan    : Magick::CyanChannel
        when :magenta : Magick::MagentaChannel
        when :yellow  : Magick::YellowChannel
        when :black   : Magick::BlackChannel
        when :alpha   : Magick::OpacityChannel
      end
    )
    self
  end
  
  # Flatten a canvas
  # 
  # Options:
  # * <tt>:bgcolor</tt> - background color to 
  #   be used when flattening transparency.
  # 
  # returns new Canvas object
  def flatten(options = {})
    self.dup.flatten!(options)
  end
  
  # In-place version of flatten
  # 
  # returns self
  def flatten!(options = {})
    return if self.opaque?
    
    options[:bgcolor] ||= '#fff'
    
    duped = self.dup
    @resource = IQ::Image::Canvas.new(
      duped.width, duped.height,
      :bgcolor => options[:bgcolor]
    ).overlay!(duped).resource
    
    self
  end
  
  # Checks to see if a Canvas has any transparency
  #
  # returns boolean
  def has_transparency?
    !@resource.opaque?
  end
  
  # Checks to see if a Canvas is opaque
  # i.e. has no transparency
  #
  # returns boolean
  def opaque?
    @resource.opaque?
  end
  
  
  # Draws text onto the canvas
  #
  # render_text!(text, options = {})
  #
  # Options:
  # * <tt>:bgcolor</tt> - background color of text
  # * <tt>:color</tt> - color of text
  # * <tt>:font</tt> - font of text
  # * <tt>:size</tt> - size of text (in points)
  # * <tt>:x_offset</tt> - x_offset of text
  # * <tt>:y_offset</tt> - y_offset of text (in points)
  #
  def render_text!(text, options = {})
    # Process the arguments
    text = text.to_s
    options.symbolize_keys!
    options[:x_offset] ||= 0
    options[:y_offset] ||= 0
  
    # Hash for mapping our types to magick types
    font_style = { :normal => Magick::NormalStyle, :italic => Magick::ItalicStyle, :oblique => Magick::ObliqueStyle }
    font_weight = { :bold => Magick::BoldWeight }
    
    # Now actually draw the text!
    renderer = Magick::Draw.new
    renderer.font = options[:font] if options[:font]
    renderer.pointsize = options[:size] if options[:size]
    renderer.fill = options[:color] if options[:color]
    renderer.fill_opacity(1)
    renderer.undercolor = options[:bgcolor] if options[:bgcolor]
    renderer.font_style = font_style[options[:style]] if options[:style] and font_style.has_key?(options[:style].to_sym)
    renderer.font_weight = font_weight[options[:style]] if options[:style] and font_weight.has_key?(options[:style].to_sym)
    renderer.gravity = Magick::SouthGravity
    #renderer.matte(0,0, Magick::ReplaceMethod) if options[:matte]
    renderer.annotate(@resource, 0, 0, options[:x_offset], options[:y_offset], text)
    
    @resource = @resource.matte_replace(0,0) if options[:matte] 
    self
  end
  
  
  # Crops the canvas
  #
  # crop(width, height, options = {})
  #
  # Options:
  # * <tt>:from</tt> - where cropping should be aligned to
  # * <tt>:x_offset</tt> - where horizontal cropping should start from (offsets from gravity edge)
  # * <tt>:y_offset</tt> - where vertical cropping should start from (offsets from gravity edge)
  # 
  # Returns new Canvas object
  def crop(width, height, options = {})
    self.dup.crop!(width, height, options)
  end
  
  # In-place version of crop!
  # 
  # Returns self
  def crop!(width, height, options = {})
    raise('Failed to supply width and height') if (width.nil? or height.nil?)
    options.symbolize_keys!
    
    gravity = gravity_to_magick_gravity(options[:from])
    if options[:x_offset] || options[:y_offset]
      @resource = @resource.crop(gravity, options[:x_offset] || 0, options[:y_offset] || 0, width, height, true)
    else
      @resource = @resource.crop(gravity, width, height, true)
    end
    self
  end
  
  # Zooms into or out of the canvas until the canvas fills the constraints
  #
  # zoom!(width, height)
  #
  def zoom!(width, height)
    raise('Failed to supply width and height') if (width.nil? or height.nil?)
    
    # Maintain aspect ratio whilst filling area
    # 
    # TODO: This only works when scaling down, do scaling up
    src_ratio  = self.width.to_f / self.height.to_f
    dest_ratio = width.to_f / height.to_f
    if (dest_ratio < src_ratio)
      new_width  = (height * src_ratio).round
      new_height = height
    else
      new_width  = width
      new_height = (width / src_ratio).round
    end

    resize!(new_width, new_height)
    #RAILS_DEFAULT_LOGGER.info "ZOOMING: #{width}x#{height} to #{new_width}x#{new_height}"

    crop!(width, height, :from => :center)
    self
  end
  
  # Applies the given canvas as an opacity mask
  # 
  # mask!(source)
  # 
  def mask!(source, options = {})
    overlay!(source, options.merge(:mode => :mask))
  end
  
  # In-place version of flip!
  # 
  # Returns self
  def flip!(direction = :vertical)
    case direction.to_s
      when 'v', 'vertical'    : @resource.flip!
      when 'h', 'horizontal'  : @resource.flop!
    end
    self
  end
  
  # Flips the canvas on the given axis
  #
  # flip(:vertical)    # To flip vertically (default option)
  # flip(:horizontal)  # To flip horizontally
  # 
  # Returns new Canvas object
  def flip(direction = :vertical)
    self.dup.flip!(direction)
  end
  
  # TODO: re-write when we have a gradient method
  def reflection!(options = {})
    options.stringify_keys!
    opacity = options['opacity'] || 20
    height  = options['height']  || (self.height.to_f / 3).round
    
    copy = self.crop(self.width, height, :y_offset => (self.height - height)).flip!
    
    from = '#' + (((opacity * 255) / 100).to_s(16).rjust(2, '0') * 3)
    grad = Magick::GradientFill.new(0, 0, 1, 0, from, '#000')
    
    mask = Magick::Image.new(self.width, height, grad)
    
    alpha_channel = copy.channel(:alpha).resource.negate
    alpha_channel.composite!(mask, 0, 0, Magick::MultiplyCompositeOp)
    alpha_channel.matte = false
    
    copy.resource.composite!(alpha_channel, 0, 0, Magick::CopyOpacityCompositeOp)
    
    dest = self.class.new(self.width, self.height + height, :bgcolor => 'transparent')
    dest.overlay!(self.dup)
    dest.overlay!(copy, :dest_y => self.height)
    @resource = dest.resource
    self
  end
  
  def border!(width, height, color)
    @resource = @resource.border(width, height, color)
    self
  end
  
  private
  
  def gravity_to_magick_gravity(gravity)
    case gravity
      when :center
        Magick::CenterGravity
      when :top
        Magick::NorthGravity
      when :top_right
        Magick::NorthEastGravity
      when :right
        Magick::EastGravity
      when :bottom_right
        Magick::SouthEastGravity
      when :bottom
        Magick::SouthGravity
      when :bottom_left
        Magick::SouthWestGravity
      when :left
        Magick::WestGravity
      else
        Magick::NorthWestGravity
    end
  end
  
end
