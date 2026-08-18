class_name MissileIndicator
extends AnimatedSprite2D

var _player: Player
var _stopped: bool = false


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if _stopped:
		return
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
	global_position.y = _player.global_position.y


func stop_movement() -> void:
	_stopped = true
	play("danger")


func start_movement() -> void:
	_stopped = false
	play("flashing")
