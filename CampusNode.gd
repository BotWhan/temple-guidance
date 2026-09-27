extends Marker3D
class_name CampusNode

#needs an adjacency matrix
@export var adjacency: Array[CampusNode] = []
@export var stairs:bool
@export var elevator:bool

#func getAdjacency():
#	return adjacency
func _ready() -> void:
	$"..".create_box(self)
