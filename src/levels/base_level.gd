class_name BaseLevel
extends Node2D

const DEFAULT_SPAWN: StringName = &"Default"

@onready var spawns: Node2D = get_node_or_null(^"Spawns")


func get_spawn_point(spawn_id: StringName = &"") -> Vector2:
	if spawns == null:
		return Vector2.ZERO

	var wanted: StringName = spawn_id if not spawn_id.is_empty() else DEFAULT_SPAWN
	var marker: Marker2D = spawns.get_node_or_null(NodePath(wanted)) as Marker2D

	if marker == null and wanted != DEFAULT_SPAWN:
		push_warning("Level has no spawn named '%s', using the default" % wanted)
		marker = spawns.get_node_or_null(NodePath(DEFAULT_SPAWN)) as Marker2D

	if marker == null:
		return Vector2.ZERO

	return marker.global_position
