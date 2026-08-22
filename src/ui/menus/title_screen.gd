extends Control


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.is_pressed():
		hide()
		SignalBus.game_started.emit()
