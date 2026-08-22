extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)
	SignalBus.level_loaded.connect(show)
	SignalBus.game_resume_requested.connect(show)
	SignalBus.player_died.connect(hide)


func _process(delta: float) -> void:
	if get_tree().paused:
		hide()


func _on_pressed() -> void:
	SignalBus.game_pause_requested.emit()
