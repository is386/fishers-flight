extends Control

func _ready() -> void:
	SignalBus.game_paused.connect(show)
	SignalBus.game_resume_requested.connect(hide)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	var dismissed: bool = event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel")
	if not dismissed:
		return

	hide()
	SignalBus.game_resume_requested.emit()
	get_viewport().set_input_as_handled()
