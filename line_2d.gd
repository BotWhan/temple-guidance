@tool
extends Line2D

var targets : PackedVector3Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targets = $"../MeshInstance3D/CampusGraph".get_path_vector($"../MeshInstance3D/CampusGraph/CampusNode1".get_instance_id(), $"../MeshInstance3D/CampusGraph/CampusNode4".get_instance_id())
	for point in targets:
		add_point(Vector2(point.x, point.y))
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
