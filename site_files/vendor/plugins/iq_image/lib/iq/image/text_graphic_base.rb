# A base class for the TextGraphicBlock and TextGraphicReplacement
# classes
#
# Author::    Andrew Montgomery  (mailto:andy@soniciq.com)
# Copyright:: Copyright (c) 2006 SonicIQ Limited
# License::   Closed source, in-house use only

class IQ::Image::TextGraphicBase
  
  VALID_OPTIONS = [ :font, :size, :color, :bgcolor, :style, :matte, :resample ]
  STYLE_TAG = { 'strong' => :bold, 'em' => :italic }

end