require 'RMagick'

module IQ # :nodoc:
  module Image # :nodoc:
    autoload(:Canvas, File.dirname(__FILE__) + "/image/canvas")
    autoload(:TextGraphic, File.dirname(__FILE__) + "/image/text_graphic")
    autoload(:TextBlockGraphic, File.dirname(__FILE__) + "/image/text_block_graphic")
    autoload(:ReplacementCSS, File.dirname(__FILE__) + "/image/replacement_css")
  end
end