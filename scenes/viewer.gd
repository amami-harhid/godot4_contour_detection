extends Sprite2D
var contour_detection:ContourDetection
func _ready() -> void:
	_test01()

func _test01()->void:
	var sprite:Sprite2D = $"../Sprite2D" # sprite original image
	var org_image:Image = sprite.texture.get_image()
	
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(
#		org_image.get_size().x+10,
#		org_image.get_size().y+10, 
		org_image.get_size().x,
		org_image.get_size().y, 
		false, Image.FORMAT_RGBA8)
	_image.fill(Color(1,1,1,0))
	_texture.set_image(_image)
	self.texture = _texture	

	var _contour_detection:ContourDetection = ContourDetection.new()
	self.contour_detection = _contour_detection
	var obj = _contour_detection.raster_scan(org_image)
	var contours = obj.contours
	#await get_tree().create_timer(3).timeout
	var count=0
	for _contour in obj.contours:
		for cell:Cell in _contour.list():
			var _pos = cell.to_vector2()
			_image.set_pixel(_pos.x, _pos.y, Color(0,0,0,1))
			_texture.set_image(_image)
			self.texture = _texture	
			await get_tree().create_timer(0.001).timeout
	print("count=",count)
func _custom_sort(a:Cell, b:Cell) -> bool:
	if a.parent < b.parent:
		return false
	return true
func _custom_sort2(a:Cell, b:Cell) -> bool:
	if a.parent == b.parent:
		if a.i == b.i :
			if a.j > b.j:
				return false
		elif a.i > b.i :
			return false
	elif a.parent > b.parent:
		return false
	
	return true
