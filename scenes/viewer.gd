extends Sprite2D
var detection:ContourDetection.Detection
func _ready() -> void:
	_test01()

func _test01()->void:
	var sprite:Sprite2D = $"../Sprite2D" # sprite original image
	
	# Create new texture( ImageTexture )
	var org_image:Image = sprite.texture.get_image()
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(
		org_image.get_size().x,
		org_image.get_size().y, 
		false, Image.FORMAT_RGBA8)
	_image.fill(Color(1,1,1,0))
	_texture.set_image(_image)
	self.texture = _texture	

	# Contour Detection
	var _detection:ContourDetection.Detection = ContourDetection.Detection.new()
	self.detection = _detection
	var contour_info:ContourDetection.ContoursInfo = _detection.raster_scan(org_image)
	# Drawing
	for _contour:ContourDetection.Contour in contour_info.list():
		#print(",nbd=",_contour.get_nbd())
		for cell:ContourDetection.Cell in _contour.list():
			var _pos = cell.to_vector2()
			_image.set_pixel(_pos.x, _pos.y, Color(0,0,0,1))
			_texture.set_image(_image)
			self.texture = _texture
			#await get_tree().create_timer(0).timeout # およそ15msの停止
		#await get_tree().create_timer(0).timeout # およそ15msの停止
