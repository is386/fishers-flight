class_name MissileIndicator
extends AnimatedSprite2D

@export var warning_sound: AudioStream
@export var warning_volume_db: float = -2.0

var _player: Player
var _stopped: bool = false


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	SignalBus.player_died.connect(_on_player_died)


func _physics_process(_delta: float) -> void:
	if _stopped:
		return
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
	global_position.y = _player.global_position.y


func stop_movement() -> void:
	AudioBus.play_sfx(warning_sound, warning_volume_db)

	_stopped = true
	play("danger")


func start_movement() -> void:
	_stopped = false
	play("flashing")


func _on_player_died() -> void:
	hide()
