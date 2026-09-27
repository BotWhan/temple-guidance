extends Node
class_name CampusGraph
#Note: CampusNodes must all be children of CampusGraph
var astar := AStar3D.new()
var node_metadata: Dictionary = {}  # id: {type, building, accessible, ...}
var stair_ids : Array[int]
var elevator_ids : Array[int]
@export var accessibility : bool#if the user wants accessibility features or not

func add_location(id: int, position: Vector3) -> void:
	astar.add_point(id, position)
	#node_metadata[id] = metadata

func connect_locations(from_id: int, to_id: int, bidirectional := true) -> void:
	astar.connect_points(from_id, to_id, bidirectional)

func get_path_vector(from_id: int, to_id: int, avoid_ids: Array[int] = []) -> PackedVector3Array:
	# temp disable avoided nodes
	for id in avoid_ids:
		if astar.has_point(id):
			astar.set_point_disabled(id, true)
	var path := astar.get_point_path(from_id, to_id)
	# reenable them
	for id in avoid_ids:
		if astar.has_point(id):
			astar.set_point_disabled(id, false)
	return path

func create_box(point: CampusNode) -> void:
	var box := MeshInstance3D.new()
	box.mesh = BoxMesh.new()
	box.scale = Vector3(0.2,0.2,0.2)
	add_child(box)
	box.global_position = point.global_position
	
func findBestPath(from: CampusNode, to:CampusNode) -> PackedVector3Array:#idk what to call this function but it
	#implements the stair/escalator logic and is the function that we want to call in general
	
	var avoidIds:Array[int] = []
	if accessibility:
		for stair in stair_ids:
			avoidIds.append(stair)
		var correctPath = get_path_vector(from.get_instance_id(), to.get_instance_id(), avoidIds)
		return correctPath
	#if accessibility not on, first try without escalators and count how many stairs we use.
	#if its over 3 then switch to using the elevator
	else:
		for elevator in elevator_ids:
			avoidIds.append(elevator)
		var checkPath = get_path_vector(from.get_instance_id(), to.get_instance_id(), avoidIds)
		return checkPath


#func _init() -> void:
func _ready() -> void:
	#alternative implementation:
	#could assume that nodes are only linked in one node's adjacency list instead of both in order to save time
	#in linking
	
	

	#need to find all children and call add location on all first, then connect locations on all after
	var children = get_children()
	for child in children:
		create_box.call_deferred(child)
		add_location(child.get_instance_id(), child.position)
		if child.stair:
			stair_ids.append(child.get_instance_id())
		elif child.elevator:
			elevator_ids.append(child.get_instance_id())
	var done : Array [int] = []#array of ids of children who we have linked all of their neighbors
	for child in children:
		for adjacentNode in child.adjacency:
			if adjacentNode.get_instance_id() not in done:
				connect_locations(child.get_instance_id(), adjacentNode.get_instance_id())
		done.append(child.get_instance_id())#we have now added all of this node's neighbors to adjacency list so
		# it can be ignored
		#when seen in future adjacency lists
	var path = findBestPath($CampusNode1, $CampusNode2)
	print(path)
	#still intention to find path between two points and draw cylinder through that line
