class_name ContourDetection
# four-connected case
"""
Direction Reference:

                1
                |
                |
         2 <- - | - -> 0
                |
                |
                3

"""
func _next_cell(curr_pixel:Cell,curr_dir:int)->CellInfo:
	var _curr_pixel:Cell = curr_pixel.duplicate()
	var _rtn_cell_info:CellInfo = CellInfo.new()
	_rtn_cell_info.save = null
	
	if curr_dir == 0 : #DIR.RIGHT:
		_rtn_cell_info.exam = Cell.new(_curr_pixel.i-1, _curr_pixel.j)
		_rtn_cell_info.new_dir = 1 #DIR.UP
		_rtn_cell_info.save = Cell.new(_curr_pixel.i, _curr_pixel.j+1)
	elif curr_dir == 1: #DIR.UP:
		_rtn_cell_info.exam = Cell.new(_curr_pixel.i, _curr_pixel.j-1)
		_rtn_cell_info.new_dir = 2  #DIR.LEFT
	elif curr_dir == 2: #DIR.LEFT:
		_rtn_cell_info.exam = Cell.new(_curr_pixel.i+1, _curr_pixel.j)
		_rtn_cell_info.new_dir = 3  #DIR.DOWN
	elif curr_dir == 3: #DIR.DOWN:
		_rtn_cell_info.exam = Cell.new(_curr_pixel.i, _curr_pixel.j+1)
		_rtn_cell_info.new_dir = 0 #DIR.RIGHT
	
	return _rtn_cell_info	#{"r":r, "c":c, "new_dir":new_dir, "save_pixel":save}

func _border_follow(img:ScanImage,start:Cell, prev:Cell, direction:int,NBD:int)->Contour:
	var _start:Cell = start.duplicate()
	var _prev:Cell = prev.duplicate()
	var _curr:Cell = start.duplicate()
	var _exam:Cell = prev.duplicate()
	var _dir:int = direction
	var _save: Cell = null
	var _save2:Cell = _exam.duplicate()
	var contour:Contour = Contour.new()	
	contour.append(_curr.duplicate())
	while img.get_value(_exam) == 0:  # while None
		var cell_info:CellInfo = _next_cell(_curr,_dir)
		_exam = cell_info.exam.duplicate()
		_dir = cell_info.new_dir
		if cell_info.save != null :
			_save = cell_info.save.duplicate()
		#print("(6)")
		if _save2.equals(_exam):
			img.set_value(_curr, -NBD)
			contour.direction = _dir
			contour.img = img
			return contour

	if _save != null:
		img.set_value(_curr, -NBD)
		_save = null
	elif (_save == null or ( _save != null and img.get_value(_save) !=0 )) and img.get_value(_curr)==1:
		img.set_value(_curr, NBD)
	else:
		pass
	_prev = _curr.duplicate()
	_curr = _exam.duplicate()
	contour.append(_curr.duplicate())
	if _dir >= 2 :
		_dir = _dir - 2
	else: 
		_dir = _dir + 2 
	var flag:int = 0
	var _start_next : Cell = _curr.duplicate()
	
	while true:
		if not( _curr.equals(_start_next) and _prev.equals(_start) and flag == 1 ):
			flag = 1
			var _cell_info_a = _next_cell(_curr, _dir)
			_exam = _cell_info_a.exam.duplicate()
			_dir = _cell_info_a.new_dir
			if _cell_info_a.save != null :
				_save = _cell_info_a.save.duplicate()
			while img.get_value(_exam) == 0:
				var _cell_info_b:CellInfo = _next_cell(_curr, _dir)
				_exam = _cell_info_b.exam.duplicate()
				_dir = _cell_info_b.new_dir
				if _cell_info_b.save != null:
					_save = _cell_info_b.save.duplicate()
				
			if _save != null and img.get_value(_save)==0:
				img.set_value(_curr,-NBD)
				_save = null
			elif (_save == null or (_save != null and img.get_value(_save)!=0)) and img.get_value(_curr)==1:
				img.set_value(_curr, NBD)
			else:
				pass
			_prev = _curr.duplicate()
			_curr = _exam.duplicate()
			contour.append(_curr.duplicate())
			if _dir >= 2 :
				_dir = _dir -2
			else:
				_dir = _dir +2
		else:
			break
	#print("last contour(2)=", contour)
	contour.direction = _dir
	contour.img = img
	return contour


func raster_scan(image: Image) -> RasterScan:
	self.scan_img = ScanImage.new(image)
	var _img:ScanImage = scan_img
	'''
	ref: https://theailearner.com/tag/suzuki-contour-algorithm-opencv/
	suzuki contour algorithm opencv
	
	NBD/LNBD
	新たに見つけたすべての境界線に一意の数字を割り当て、それをNBDで表します
	フレームのNBDを1と仮定します。休みの境界線は順番に番号付けされます。
	任意の境界の親情報はLNBDまたは最後のNBDに保存します。
	'''
	var NBD:int = 1 
	var LNBD:int = 1
	var direction:int
	var contours:Array[Contour]=[]
	var parent:Array[int]=[-1]			# 初期要素 -1
	var border_type:Array[int] = [0]	# 初期要素 0
	'''
	画像を左から右へスキャンし、対象ピクセルを見つけます。
	それが外縁か穴の境界かを判断します。外縁や穴の境界を確認する基準は下の画像に示されています。
	したがって、スキャン時に下の画像のような状況が見つかれば、それが外縁の開始点(Outerborder)か
	穴の境界(Hollboarder)かを簡単に判断できます。
	
        [Outer border]               [Holl border]
         j - 1   j                      j    j + 1
	    +-----+-----+                +------+------+
	(i) |  0  |  1  |            (i) | >= 1 |   0  |
	    +-----+-----+                +------+------+
	
	以下の手順はピクセル>0のみを行う。新しい行をスキャンし始めるたびに、LNBDを1にリセットする
	【STEP01】
	(1) もし外側の境界線なら NBDを1増やし、(i2, j2)<=(i, j-1) とする。
	(2) もし穴の境界線なら NBDを1増やし、(i2, j2)<=(i, j+1) とし、f(i,j)>1のときLNBD<=f(i,j) とする
	(3) 以外の場合は STEP3 へ。
	【STEP02】
	(1) [i2,j2]を基準にして 周辺のピクセルを時計回りに、ゼロでないピクセルを見つけ、それを[i1, j1]とする。
	    ゼロのピクセルが見つからない場合は f(i,j)<= -NBD とし、STEP04へ。
	(2) (i2,j2)<=(i1,j2)、(i3,j3)<=(i,j) とする。
	(3) (i3,j3)の近傍を反時計回りに走査して最初のゼロでないピクセルを見つけ、みつけたピクセルを(i4, j4)とする。
	(4) 現時点の(i3,j3)を次のように変更する
		1. (i3,j3+1)が 境界外(0)ピクセルのとき f(i3,j3)= -NBDとする
		2. (i3,j3+1)が 境界外(0)ピクセルでなく f(i3,j3) == 1 のときは　NBD = f(i3,j3)とする
		3. それ以外の場合は変更しない
	(5) STEP02(2)で出発点に戻る場合 つまり、(i4,j4)==(i,j)and(i3,j3)==(i1,j1)のとき、STEP03へ。
	　　そうでないときは、
	    1. (i2,j2)=(i3,j3)とする
		2. (i3,j3)=(i4,j4)とする
		3. STEP02(3)に戻る。
	【STEP03】
	(1) もし f(i,j) != 1 であれば LNBD = 絶対値( f(i,j) )
	(2) 次のピクセル (i,j+1)からスキャンを開始する
	(3) 停止するのは、画像の右下隅に到達したときである
	'''
	for i in range(1, _img.rows-1): # 縦方向(行)
		LNBD = 1
		for j in range(1, _img.cols-1): # 横方向
			var cell0:Cell = Cell.new(i,j)
			if _img.get_value(cell0) == 1 and _img.get_value_i(i, j-1)==0:
				var cell2:Cell = Cell.new(i, j-1)
				# if Outer border
				NBD += 1 # increment NBD
				direction = 2 # LEFT
				parent.append(LNBD)
				var contour:Contour = _border_follow(_img, cell0, cell2, direction, NBD)
				direction = contour.direction
				_img = contour.img
				contour.parent = LNBD
				contours.append(contour)
				border_type.append(1) # 上が 0
				if border_type[NBD-2]==1:
					parent.append(parent[NBD-2])
				else:
					if _img.get_value_i(i, j) != 1 :
						LNBD = abs(_img.get_value_i(i, j))
				
			elif _img.get_value(cell0) >= 1 and _img.get_value_i(i, j+1)==0: 
				# if Holl border 
				var cell2:Cell = Cell.new(i, j+1)
				NBD += 1
				direction = 0 # RIGHT
				if _img.get_value(cell0) > 1:
					LNBD = _img.get_value(cell0)
				parent.append(LNBD)
				var contour = _border_follow(_img, cell0, cell2, direction, NBD)
				direction = contour.direction
				_img = contour.img
				contour.parent = LNBD
				#print("#0004")
				contours.append(contour)
				border_type.append(0) # 下が 0
				if border_type[NBD-2]==0:
					parent.append(parent[NBD-2])
				else:
					if _img.get_value(cell0) != 1:
						LNBD = abs(_img.get_value(cell0))
			
	var _raster_scan = RasterScan.new()
	_raster_scan.contours = contours
	_raster_scan.parent = parent
	_raster_scan.border_type = border_type
	return _raster_scan
	
var scan_img:ScanImage	
