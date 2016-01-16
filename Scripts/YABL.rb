module YABL
	#unsigned destObjectID, long destBmpWidth, long destBmpHeight,
	#long destX, long destY, 
	#unsigned srcObjectID, long srcBmpWidth, long srcBmpHeight,
	#long srcX, long srcY, long srcWidth, long srcHeight,
  #long blendType, BYTE opacity
  YABL_BlendBlt = Win32API.new('YABL/Release/YABL.dll', 'BlendBlt', 'llllllllllllli', 'v')
  def blt(dest, dest_x, dest_y, src, src_x, src_y, src_w, src_h, type = 0, opacity = 255)
    YABL_BlendBlt.call(dest.object_id, dest.width, dest.height, 
      dest_x, dest_y,
      src.object_id, src.width, src.height, 
      src_x, src_y, src_w, src_h,
      type, opacity)
  end
  
  
  def self.test
    p "YABL.test"
    @sprite = Sprite.new
    @sprite.z = 10000
    dest = Bitmap.new(Graphics.width, Graphics.height)
    dest.fill_rect(0, 0, dest.width, dest.height, Color.new(255, 255, 255))
    @sprite.bitmap = dest
  end
end