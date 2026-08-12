extends Node2D

@export var hazard_scene: PackedScene
@export var entity_root: Node2D

var _spawn_timer: Timer


func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.autostart = true
	_spawn_timer.wait_time = 3
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(_spawn_timer)


func _on_spawn_timer_timeout() -> void:
	var hazard := hazard_scene.instantiate() as Hazard
	hazard.length = 3
	hazard.type = hazard.HazardType.HORIZONTAL
	hazard.global_position = global_position
	entity_root.add_child(hazard)
