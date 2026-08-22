extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	SignalBus.level_loaded.connect(hide)
	SignalBus.game_resume_requested.connect(hide)
	SignalBus.player_died.connect(hide)


func _process(delta: float) -> void:
	if get_tree().paused:
		show()


func _on_pressed() -> void:
	SignalBus.game_resume_requested.emit()
