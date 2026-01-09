extends Sprite2D

@onready var sprite:Sprite2D = $"../Sprite2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var image:Image = sprite.texture.get_image()
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)
	_image.fill(Color(0,0,0,0))
	_texture.set_image(_image)
	self.texture = _texture
	
	var contour_detection = ContourDetection.new()
	var obj = contour_detection.raster_scan(image)
	var contours = obj.contours
	var parent = obj.parent
	var border_type = obj.border_type
	#print("contours=", contours)
	#print("parent=", parent)
	#print("border_type=",border_type)
	var idx = 0
	for contour:Contour in obj.contours:
		idx += 1
		var _p = parent.get(idx)
		#print("parent=",_p, " ,contour=",contour)
		for cell: Cell in contour.list():
			_image.set_pixel(cell.i, cell.j, Color(0,0,0,1))
		#await get_tree().create_timer(0.1).timeout

	_texture.set_image(_image)
	self.texture = _texture
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
