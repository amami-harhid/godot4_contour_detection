class_name Cell

var i:int
var j:int
var parent:int

func _init(_i:int=-int(INF), _j:int=-int(INF)):
	self.i = _i
	self.j = _j
	self.parent = 0
	
func list()->Array[int]:
	return [self.i, self.j]
	
func duplicate()->Cell:
	var _cell:Cell = Cell.new(self.i, self.j)
	_cell.parent = self.parent
	return _cell
	
func equals(target:Cell)->bool:
	if self.i == target.i and self.j == target.j :
		return true
	else:
		return false

func to_vector2()->Vector2:
	return Vector2(j-1, i-1)

func _to_string() -> String:
	return "[parent=%d,i=%d,j=%d]"%[parent,i,j]
