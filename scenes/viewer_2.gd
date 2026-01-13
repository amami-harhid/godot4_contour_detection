extends Sprite2D

@onready var sprite:Sprite2D = $"../Sprite2D"
@onready var viewer:Sprite2D = $"../Viewer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test01()

func _test01()->void:
	var image:Image = sprite.texture.get_image()
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(image.get_size().x+2, image.get_size().y+10, false, Image.FORMAT_RGBA8)
	_image.fill(Color(0,0,0,0))
	_texture.set_image(_image)
	self.texture = _texture
	#await get_tree().create_timer(0.5).timeout
	var contour_detection = viewer.contour_detection
	var img:ScanImage = contour_detection.scan_img
	print("_image size=",_image.get_size())
	print("img size=", img._img.size(),",", img._img.get(0).size())
	print("rows,cols=", img.rows,",", img.cols)
	for i in img.cols:
		for j in img.rows:
			if img.get_init_value_i(j, i) > 0:
				_image.set_pixel(i, j, Color(0,0,0,1))
			
	_texture.set_image(_image)
	self.texture = _texture	
