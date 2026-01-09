class_name Cell

var i:int
var j:int

func _init(_i:int=-int(INF), _j:int=-int(INF)):
	self.i = _i
	self.j = _j

func list()->Array[int]:
	return [self.i, self.j]
	
func duplicate()->Cell:
	return Cell.new(self.i, self.j)
	
func equals(target:Cell)->bool:
	if self.i == target.i and self.j == target.j :
		return true
	else:
		return false
		
func _to_string() -> String:
	return "[i=%d,j=%d]"%[i,j]
