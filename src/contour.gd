class_name Contour

var _contour:Array[Cell]
var _regex:RegEx

var parent:int: set=set_parent
func set_parent(_parent:int)->void:
	for _cell:Cell in _contour:
		_cell.parent = _parent

var direction:int
var img:ScanImage

func _init():
	self._contour = []
	self._regex = RegEx.new()
	self._regex.compile(",$")

func append(element: Cell)->void:
	_contour.append(element)



func getElement(indx: int) -> Cell:
	var element:Cell = self._contour.get(indx)
	return element

func list()->Array[Cell]:
	return _contour

func _to_string() -> String:
	var _str = ""
	for cell in _contour:
		_str += cell.to_string() + ","
	if not _str.is_empty():
		var _str2 = _str.substr(0, _str.length()-1)
		return "[" + _str2 + "]"
	return ""
