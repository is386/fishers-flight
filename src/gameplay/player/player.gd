class_name Player
extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()
