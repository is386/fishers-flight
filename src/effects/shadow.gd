class_name Shadow
extends Sprite2D

var SCALE := 1.5

var _player: Player


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if not _player:
		return

	if _player.is_on_floor():
		scale = Vector2(SCALE, SCALE)
	else:
		var diff := absf(_player.global_position.y - global_position.y)
		scale = Vector2(SCALE - (diff / get_viewport_rect().size.y * 2), SCALE)
