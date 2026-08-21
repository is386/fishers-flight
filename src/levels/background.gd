extends Parallax2D

var _game_manager: GameManager


func _ready() -> void:
	_game_manager = get_tree().get_first_node_in_group("game_manager")
	autoscroll.x = -_game_manager.speed


func _physics_process(_delta: float) -> void:
	autoscroll.x = -_game_manager.speed
