extends Sprite2D

@onready var sprite:Sprite2D = $"../Sprite2D"
var contour_detection:ContourDetection
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test01()

func _test01()->void:
	contour_detection = ContourDetection.new()
	var image:Image = sprite.texture.get_image()
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(image.get_size().x+10, image.get_size().y+10, false, Image.FORMAT_RGBA8)
	_image.fill(Color(1,1,1,1))
	_texture.set_image(_image)
	self.texture = _texture
	
	var obj = contour_detection.raster_scan(image)
	var contours = obj.contours
	#var parent = obj.parent
	#ar border_type = obj.border_type
	#print("contours=", contours)
	var _contours:Array[Contour] = obj.contours.duplicate(true)
	var _cell_arr:Array[Cell]=[]
	for contour:Contour in _contours:
		for cell: Cell in contour.list():
			_cell_arr.append(cell)
	_cell_arr.sort_custom(self._custom_sort2)
	for cell:Cell in _cell_arr:
		_image.set_pixel(cell.j, cell.i, Color(0,0,0,1))
		#await get_tree().create_timer(0.01).timeout
		_texture.set_image(_image)
		self.texture = _texture	
		
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
