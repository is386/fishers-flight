extends Node2D

@export var hazard_scene: PackedScene
@export var entity_root: Node2D
@export var camera: Camera2D

var _max_y: float
var _max_hazards: int = 1
var _num_hazards: int = 0
var _hazard_speed_increment: float = 0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	_max_y = get_viewport_rect().size.y / camera.zoom.y / 2

	SignalBus.milestone_reached.connect(_on_milestone_reached)
	SignalBus.player_died.connect(_on_player_died)


func _physics_process(_delta: float) -> void:
	_hazard_speed_increment += 0.006


func _on_spawn_timer_timeout() -> void:
	if _num_hazards == _max_hazards:
		spawn_timer.stop()
		return

	_num_hazards += 1

	var hazard := hazard_scene.instantiate() as Hazard
	hazard.speed = floor(hazard.speed + _hazard_speed_increment)
	hazard.length = randi_range(3, 5)
	hazard.type = randi_range(0, 3)
	hazard.rotating = randi_range(1, 10) == 5

	var y := randf_range(-_max_y, _max_y)
	var height := hazard.BLOCK_SIZE

	if hazard.type != hazard.HazardType.HORIZONTAL:
		height = (hazard.length + 1) * (hazard.BLOCK_SIZE / 2)

	if y + height > _max_y:
		y -= height
	elif y - height < -_max_y:
		y += height

	hazard.global_position = Vector2(global_position.x, y)
	entity_root.add_child(hazard)
	hazard.despawned.connect(_on_hazard_despawned)


func _on_hazard_despawned() -> void:
	_num_hazards = max(0, _num_hazards - 1)
	if _num_hazards == 0:
		spawn_timer.start()


func _on_milestone_reached() -> void:
	_max_hazards += 1
	spawn_timer.wait_time = max(0.5, spawn_timer.wait_time - 0.75)


func _on_player_died() -> void:
	queue_free()
