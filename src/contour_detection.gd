## ContourDetection class
## Suzuki85 edge detection program code written in GDScript.
## Original code was written in Python ( Rajdeep Mondal ).  
class_name ContourDetection

## 方向回転量
class DireRotation:
	## 時計回り=2
	const Clockwise:int = -2
	## 反時計回り=2
	const Counterclockwise:int = 2

## 方向のコンスタント定義
class Direction:
	#                1
	#                |
	#         2 <- - | - -> 0
	#                |
	#                3
	## 右方向
	const RIGHT:int = 0
	## 上方向
	const UP:int = 1
	## 左方向
	const LEFT:int = 2
	## 下方向
	const DOWN:int = 3
	var _direction:int = LEFT: get=get_direction, set=set_direction
	## 方向を取得する
	func get_direction()->int:
		return _direction
	## 方向を設定する
	## @param _dir 方向
	func set_direction(_dir:int)->void:
		_direction = _dir	

#
# 境界の種類
#
## 境界種類のコンスタント定義
class Border:
	## 境界(外)
	const Outer:int = 1
	## 境界(穴)
	const Hole:int = 0

## ScanImage クラス
class ScanImage:
	const ON = 1
	const OFF = 0
	## オリジナルイメージ
	var image:Image
	## ２値化配列
	var _img:Array[Array]
	var _img_init:Array[Array]
	## 行数
	var rows: int
	## カラム数
	var cols: int
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
						var pixel = get_pixel(image,i,j)
						if pixel.a > 0:
							_img_rows.append(ON)
						else:
							_img_rows.append(OFF)
				_img.append(_img_rows)
		_img_init = _img.duplicate()

	## ピクセルを取得
	## @param img Image
	## @param i 行
	## @param j カラム
	func get_pixel(img: Image, i:int, j:int)->Color:
		var size = img.get_size()
		if 0< i and 0<j and i < size.y and j < size.x:
			var _px:Color = img.get_pixel(j, i) # x=j, y=i
			return _px
		return Color(0,0,0,0)
	
	## ２値化配列から指定要素の値を取り出す
	## @param cell:Cell セル情報
	func get_value(cell:Cell)->int:
		if cell != null:
			var i:int = cell.i	# 縦
			var j:int = cell.j	# 横
			return get_value_i(i,j)
		return OFF
	
	## ２値化配列から指定要素の値を取り出す
	## @param i 行
	## @param j カラム
	func get_value_i(i:int, j:int)->int:
		if 0 <= i and 0 <= j and i < rows and j < cols:
			return self._img.get(i).get(j)
		return OFF
	
	## ２値化オリジナル配列から指定要素の値を取り出す
	## @param i 行
	## @param j カラム
	func get_init_value_i(i:int, j:int)->int:
		if 0 <= i and 0 <= j and i < rows and j < cols:
			return self._img_init.get(i).get(j)
		return OFF
		
	## ２値化配列の指定要素へ値を設定する
	## @param cell:Cell セル情報
	## @param value 整数型の値
	func set_value(cell:Cell, value:int)->void:
		if cell != null:
			var i:int = cell.i	# 縦
			var j:int = cell.j	# 横
			if 0 <= i and 0 <= j and i < rows and j < cols:
				self._img.get(i).set(j, value)

## セル情報
class Cell:
	## 行
	var i:int
	## カラム
	var j:int

	func _init(_i:int=-int(INF), _j:int=-int(INF)):
		self.i = _i
		self.j = _j
		
	## 行,カラムを配列にする
	func list()->Array[int]:
		return [self.i, self.j]

	## 複製を作る
	func duplicate()->Cell:
		var _cell:Cell = Cell.new(self.i, self.j)
		#_cell.parent = self.parent
		return _cell

	## 等価であることを調べる
	func equals(target:Cell)->bool:
		if self.i == target.i and self.j == target.j :
			return true
		else:
			return false

	## 行,カラムを設定する
	func set_ij(_i:int, _j:int)->void:
		self.i = _i
		self.j = _j
		
	## 行,カラムを Vector2(カラム,行)にして返す
	func to_vector2()->Vector2:
		return Vector2(j-1, i-1)

	## 文字列化
	func _to_string() -> String:
		return "[i=%d,j=%d]"%[i,j]

## Contourクラス
class Contour:
	## セル情報の配列
	var _contour:Array[Cell]
	
	func _init():
		self._contour = []

	## セル情報を追加する
	func append(element: Cell)->void:
		_contour.append(element)

	## セル情報を取得する
	## @param indx 配列インデクス
	func getElement(indx: int) -> Cell:
		var element:Cell = self._contour.get(indx)
		return element

	## セル情報配列を返す
	func list()->Array[Cell]:
		return _contour

	## 文字列化
	func _to_string() -> String:
		var _str = ""
		for cell in _contour:
			_str += cell.to_string() + ","
		if not _str.is_empty():
			var _str2 = _str.substr(0, _str.length()-1)
			return "[" + _str2 + "]"
		return ""

## CellInfo クラス
class CellInfo:
	## 試行点のセル情報
	var exam: Cell
	#var new_dir:Direction = Direction.new()
	## 輪郭の最初の点
	var save:Cell

## ContoursInfo クラス
class ContoursInfo:
	## 輪郭情報Contourの配列
	var contours:Array[Contour]
	## 親情報の配列
	var parents: Array[int]
	## 境界種類の配列
	var border_types: Array[int]
	## 輪郭情報の配列を返す
	func list()->Array[Contour]:
		return self.contours
	## 境界種類の配列を返す	
	func border_type_list()->Array[int]:
		return self.border_types
	## 親情報の配列を返す
	func parent_list()->Array[int]:
		return self.parents

## 輪郭抽出用クラス
class Detection:
		
	var scan_img:ScanImage

	## 向き(Direction)を変えて次候補を決め、引数(exam)を上書きする
	func _next_cell(curr_pixel:Cell,direction:Direction, exam:Cell)->CellInfo:
		var _curr_pixel:Cell = curr_pixel.duplicate()
		var _next_cell_info:CellInfo = CellInfo.new()
		_next_cell_info.save = null
	
		if direction._direction == Direction.RIGHT :
			exam.set_ij(curr_pixel.i-1, curr_pixel.j)
			direction._direction = Direction.UP
			_next_cell_info.save = Cell.new(curr_pixel.i, curr_pixel.j+1)
		elif direction._direction == Direction.UP: #DIR.UP:
			exam.set_ij(curr_pixel.i, curr_pixel.j-1)
			direction._direction = Direction.LEFT
		elif direction._direction == Direction.LEFT:
			exam.set_ij(curr_pixel.i+1, curr_pixel.j)
			direction._direction = Direction.DOWN
		elif direction._direction == Direction.DOWN:
			exam.set_ij(curr_pixel.i, curr_pixel.j+1)
			direction._direction = Direction.RIGHT
	
		# Return an object instead of a tuple
		return _next_cell_info

	## 境界を追跡し、境界情報(contour)を返す
	func _border_follow(img:ScanImage,start:Cell, prev:Cell, direction:Direction, NBD:int)->Contour:
		var _start:Cell = start.duplicate()
		var _prev:Cell = prev.duplicate()
		var _curr:Cell = start.duplicate()
		var _exam:Cell = prev.duplicate()
		var _save: Cell = null
		var _save2:Cell = _exam.duplicate()
		var contour:Contour = Contour.new()	
		contour.append(_curr.duplicate())
		while img.get_value(_exam) == ScanImage.OFF:  # while OFF
			var cell_info:CellInfo = _next_cell(_curr,direction, _exam)
			if cell_info.save != null :
				_save = cell_info.save.duplicate()
			if _save2.equals(_exam):
				img.set_value(_curr, -NBD)
				return contour

		if _save != null:
			img.set_value(_curr, -NBD)
			_save = null
		elif (_save == null or ( _save != null and img.get_value(_save) !=ScanImage.OFF )) and img.get_value(_curr)==ScanImage.ON:
			img.set_value(_curr, NBD)
		else:
			pass
		_prev = _curr.duplicate()
		_curr = _exam.duplicate()
		contour.append(_curr.duplicate())
		if direction._direction >= Direction.LEFT :
			direction._direction += DireRotation.Clockwise # 時計回りに２つまわす
		else:
			direction._direction += DireRotation.Counterclockwise # 反時計回りに２つまわす
		var flag:int = 0
		var _start_next : Cell = _curr.duplicate()
		while true:
			if not( _curr.equals(_start_next) and _prev.equals(_start) and flag == 1 ):
				flag = 1
				var _cell_info_a = _next_cell(_curr, direction, _exam)
				if _cell_info_a.save != null :
					_save = _cell_info_a.save.duplicate()
				while img.get_value(_exam) == ScanImage.OFF:
					var _cell_info_b:CellInfo = _next_cell(_curr, direction, _exam)
					if _cell_info_b.save != null:
						_save = _cell_info_b.save.duplicate()
				
				if _save != null and img.get_value(_save)==ScanImage.OFF:
					img.set_value(_curr,-NBD)
					_save = null
				elif (_save == null or (_save != null and img.get_value(_save)!=ScanImage.OFF)) and img.get_value(_curr)==ScanImage.ON:
					img.set_value(_curr, NBD)
				else:
					pass
				_prev = _curr.duplicate()
				_curr = _exam.duplicate()
				contour.append(_curr.duplicate())
				if direction._direction >= Direction.LEFT :
					direction._direction += DireRotation.Clockwise # 時計回りに２つまわす
				else:
					direction._direction += DireRotation.Counterclockwise # 反時計回りに２つまわす
			else:
				break
		return contour

	## 画像を２値化したうえで走査し、境界情報を追跡する
	func raster_scan(image: Image) -> ContoursInfo:
		self.scan_img = ScanImage.new(image)
		var _img:ScanImage = scan_img
		var NBD:int = 1 
		var LNBD:int = 1
		var direction:Direction = Direction.new()
		var contours:Array[Contour]=[]
		var parents:Array[int]=[-1]			# 初期要素 -1
		var border_types:Array[int] = [Border.Hole]
		for i in range(1, _img.rows-1): # 縦方向(行)
			LNBD = 1
			for j in range(1, _img.cols-1): # 横方向
				var cell0:Cell = Cell.new(i,j)
				if _img.get_value(cell0) == ScanImage.ON and _img.get_value_i(i, j-1)==ScanImage.OFF:
					# if Outer border
					var cell2:Cell = Cell.new(i, j-1)
					NBD += 1 # increment NBD
					direction._direction = Direction.LEFT
					parents.append(LNBD)
					var contour:Contour = _border_follow(_img, cell0, cell2, direction, NBD)
					contours.append(contour)
					border_types.append( Border.Outer ) # Outer border=1
					if border_types[NBD-2]==Border.Outer:
						parents.append(parents[NBD-2])
					else:
						if _img.get_value_i(i, j) != ScanImage.ON :
							LNBD = abs(_img.get_value_i(i, j))
				
				elif _img.get_value(cell0) >= ScanImage.ON and _img.get_value_i(i, j+1)==ScanImage.OFF: 
					# if Hole border 
					var cell2:Cell = Cell.new(i, j+1)
					NBD += 1
					direction._direction = Direction.RIGHT # RIGHT
					if _img.get_value(cell0) > ScanImage.ON:
						LNBD = _img.get_value(cell0)
					parents.append(LNBD)
					var contour = _border_follow(_img, cell0, cell2, direction, NBD)
					contours.append(contour)
					border_types.append( Border.Hole) # Hole border = 0
					if border_types[NBD-2]== Border.Hole:
						parents.append(parents[NBD-2])
					else:
						if _img.get_value(cell0) != ScanImage.ON:
							LNBD = abs(_img.get_value(cell0))

		var _contours_info = ContoursInfo.new()
		_contours_info.contours = contours
		_contours_info.parents = parents
		_contours_info.border_types = border_types
		return _contours_info
	
