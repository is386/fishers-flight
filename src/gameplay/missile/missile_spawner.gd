extends Node2D

@export var missile_scene: PackedScene
@export var entity_root: Node2D
@export var missile_indicator: MissileIndicator

var _player: Player

@onready var spawn_timer: Timer = $SpawnTimer
@onready var aim_timer: Timer = $AimTimer
@onready var shoot_timer: Timer = $ShootTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	aim_timer.timeout.connect(_on_aim_timer_timeout)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	missile_indicator.hide()
	_player = get_tree().get_first_node_in_group("player")

	SignalBus.player_died.connect(_on_player_died)


func _on_spawn_timer_timeout() -> void:
	missile_indicator.start_movement()
	missile_indicator.show()
	aim_timer.start()


func _on_aim_timer_timeout() -> void:
	missile_indicator.stop_movement()
	shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	missile_indicator.hide()
	var missile := missile_scene.instantiate() as Missile
	missile.global_position = Vector2(global_position.x, missile_indicator.global_position.y)
	entity_root.add_child(missile)


func _on_player_died() -> void:
	queue_free()
