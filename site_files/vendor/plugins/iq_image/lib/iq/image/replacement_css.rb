# A class that replaces text with images and CSS
# classes
#
# Author::    Andrew Montgomery  (mailto:andy@soniciq.com)
# Copyright:: Copyright (c) 2006 SonicIQ Limited
# License::   Closed source, in-house use only

class IQ::Image::ReplacementCSS
  
  MY_OPTIONS = [ :format, :image_dir, :transform ]
  
  def initialize(tag, text, options = {}, styles = {})
    @tag  = tag
    @text = text
    
    
    @image_rel_dir = (options[:image_dir] ||  'headings')
    @image_dir = File.join(RAILS_ROOT, 'public', @image_rel_dir)
    FileUtils.mkpath @image_dir unless File.exist?(@image_dir) 
    
    @image_format = options[:format] || 'gif'
    
    text_block = options[:transform] ? @text.send(options[:transform]) : @text
    
    options = options.reject { |k,v| MY_OPTIONS.include?(k) }
    
    @hash = Digest::MD5.hexdigest("#{tag}#{text}#{options}#{styles}")
    
    unless File.exist?(File.join(@image_dir, "#{@hash}.#{@image_format}")) 
      @text_graphic = IQ::Image::TextGraphic.new(text_block, options, styles)
      @text_graphic.canvas.write(File.join(@image_dir, "#{@hash}.#{@image_format}"))
    else
      @text_graphic = IQ::Image::Canvas.read(File.join(@image_dir, "#{@hash}.#{@image_format}"))
    end
  end
  
  def to_css
    <<-CSS
    .ir_#{@hash} {
      background: url(#{File.join('/', @image_rel_dir, @hash)}.#{@image_format}) top left no-repeat;
      padding: #{@text_graphic.height}px 0 0 0;
      overflow: hidden;
      width: #{@text_graphic.width}px;
      height: 0px !important;
      height /**/: #{@text_graphic.height}px; /* for IE5/Win only */
    }
    CSS
  end
  
  def to_html
    "<#{@tag} class=\"ir_#{@hash}\">#{@text}</#{@tag}>"
  end

end