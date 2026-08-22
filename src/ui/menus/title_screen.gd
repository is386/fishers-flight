extends Control


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if not event.is_action_pressed("fly"):
		return

	hide()
	SignalBus.game_started.emit()
	get_viewport().set_input_as_handled()
