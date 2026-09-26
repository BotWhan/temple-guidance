extends Node
class_name CampusGraph

var astar := AStar3D.new()
var node_metadata: Dictionary = {}  # id: {type, building, accessible, ...}

func add_location(id: int, position: Vector3, metadata: Dictionary) -> void:
	astar.add_point(id, position)
	node_metadata[id] = metadata

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


func _init() -> void:
	#need to find all children and call add location on all first, then connect locations on all after
	var children = get_children()
	for child in children:
		add_location(child.id, child.position, child.metadata)
	var done : Array [int] = []#array of ids of children who we have linked all of their neighbors
	for child in children:
		for adjacentNode in child.Adjacency:
			if adjacentNode.id not in done:
				connect_locations(child.id, adjacentNode.id)
		done.append(child.id)#we have now added all of this node's neighbors to adjacency list so it can be ignored
		#when seen in future adjacency lists
