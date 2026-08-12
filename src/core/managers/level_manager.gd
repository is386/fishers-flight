class_name LevelManager
extends Node

@export var level_root_path: NodePath = ^""

var current_level: BaseLevel = null

@onready var level_root: Node2D = get_node_or_null(level_root_path) as Node2D


func _ready() -> void:
	SignalBus.game_exit_to_title_requested.connect(unload_current_level)


func load_level(level_uid: String) -> BaseLevel:
	if level_root == null:
		push_error("LevelManager has no level_root assigned")
		return null

	var packed: PackedScene = ResourceLoader.load(level_uid, "PackedScene") as PackedScene
	if packed == null:
		push_error("Could not load level as a packed scene: " + level_uid)
		return null

	var level: BaseLevel = packed.instantiate() as BaseLevel
	if level == null:
		push_error("Level scene does not extend BaseLevel: " + level_uid)
		return null

	unload_current_level()

	await get_tree().process_frame

	current_level = level
	level_root.add_child(level)

	await get_tree().process_frame

	return current_level


func unload_current_level() -> void:
	if current_level == null:
		return

	SignalBus.level_unloading.emit()
	current_level.queue_free()
	current_level = null
