class_name ScanImage
var image:Image
var _img:Array[Array]
var rows: int
var cols: int
const ON = 1
const OFF = 0
func _init(_image: Image):
	image = _image
		# ２値化
	_img = []
	var size:Vector2i = image.get_size()
	rows = size.y
	cols = size.x
	for y in range(rows+2):
		if y == 0 or y == rows+1:
			var _img_rows: Array[int]=[]
			for x in range(cols+2):
				_img_rows.append(OFF)
			_img.append(_img_rows)
		else:
			var _img_rows: Array[int]=[]
			for x in range(cols+2):
				if x == 0 or x == rows + 1:
					_img_rows.append(OFF)
				else:
					var pixel = image.get_pixel(x,y)
					if pixel.a > 0:
						_img_rows.append(ON)
					else:
						_img_rows.append(OFF)
			_img.append(_img_rows)
	rows += 2
	cols += 2

func get_value(cell:Cell)->int:
	if cell != null:
		var x:int = cell.i
		var y:int = cell.j
		return get_value_i(x,y)
	return OFF
	
func get_value_i(x:int, y:int)->int:
	#print("rows=",rows, ",cols=",cols, ",y=",y, ",x=",x)
	if 0 <= x and 0 <= y and x < image.get_size().x and y < image.get_size().y:  
		#print("self._img.get(y)=",self._img.get(y))
		return self._img.get(y).get(x)
	return OFF
	
		
func set_value(cell:Cell, value:int)->void:
	if cell != null:
		var x:int = cell.i
		var y:int = cell.j
		if 0 <= x and 0 <= y and x < image.get_size().x and y < image.get_size().y:  
			_img.get(y).set(x, value)
	
