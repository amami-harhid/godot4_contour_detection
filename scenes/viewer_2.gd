extends Sprite2D

@onready var sprite:Sprite2D = $"../Sprite2D"
@onready var viewer:Sprite2D = $"../Viewer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_test01()

func _test01()->void:
	# 元画像をもつSprite2Dノードから画像を取得（サイズを知るために）
	var image:Image = sprite.texture.get_image()
	# 新しい ImageTextureを作る、新しい画像を作る（ピクセルを全て透明にする）
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(image.get_size().x+2, image.get_size().y+10, false, Image.FORMAT_RGBA8)
	_image.fill(Color(0,0,0,0))
	# 一旦、自身のtexureを上書きする
	_texture.set_image(_image)
	self.texture = _texture

	# Viewerノードの contour_detectionを参照し２値画像を取得する
	var _detection = viewer.detection
	var img:ContourDetection.ScanImage = _detection.scan_img
	
	# ２値画像を描画する
	for i in img.cols:
		for j in img.rows:
			if img.get_init_value_i(j, i) > 0:
				_image.set_pixel(i, j, Color(0,0,0,1))
	
	# textureを入れ替える
	_texture.set_image(_image)
	self.texture = _texture	
