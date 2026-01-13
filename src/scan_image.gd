class_name ScanImage
var image:Image
var _img:Array[Array]
var _img_init:Array[Array]
var rows: int
var cols: int
const ON = 1
const OFF = 0
func _init(_image: Image):
	
	image = _image
		# ２値化
	_img = []
	_img_init = []
	var size:Vector2i = image.get_size()
	rows = size.y
	cols = size.x

	for i in range(rows): # 縦方向
		if i == 0 or i == rows-1:
			var _img_rows: Array[int]=[]
			for j in range(cols):  # 横方向
				_img_rows.append(OFF)
			_img.append(_img_rows)
		else:
			var _img_rows: Array[int]=[]
			for j in range(cols): # 横方向
				if j == 0 or j == cols - 1:
					_img_rows.append(OFF)
				else:
					var pixel = get_pixcel(image,i,j)
					if pixel.a > 0:
						_img_rows.append(ON)
					else:
						_img_rows.append(OFF)
			_img.append(_img_rows)
	_img_init = _img.duplicate()

func get_pixcel(img: Image, i:int, j:int)->Color:
	var size = img.get_size()
	if 0< i and 0<j and i < size.y and j < size.x:
		var _px:Color = img.get_pixel(j, i) # x=j, y=i
		return _px
	return Color(0,0,0,0)
	
func get_value(cell:Cell)->int:
	if cell != null:
		var i:int = cell.i	# 縦
		var j:int = cell.j	# 横
		return get_value_i(i,j)
	return OFF
	
func get_value_i(i:int, j:int)->int:
	#print("rows=",rows, ",cols=",cols, ",y=",y, ",x=",x)
	if 0 <= i and 0 <= j and i < rows and j < cols:
		#print("self._img.get(y)=",self._img.get(y))
		return self._img.get(i).get(j)
	return OFF
	
func get_init_value_i(i:int, j:int)->int:
	#print("rows=",rows, ",cols=",cols, ",y=",y, ",x=",x)
	if 0 <= i and 0 <= j and i < rows and j < cols:
		#print("self._img.get(y)=",self._img.get(y))
		return self._img_init.get(i).get(j)
	return OFF
		
func set_value(cell:Cell, value:int)->void:
	if cell != null:
		var i:int = cell.i	# 縦
		var j:int = cell.j	# 横
		if 0 <= i and 0 <= j and i < rows and j < cols:
			self._img.get(i).set(j, value)
	
