extends Control

@export var level_uid: String = ""

@onready var settings_button: Button = %SettingsButton


func _ready() -> void:
	settings_button.pressed.connect(_on_settings_button_pressed)
	SignalBus.game_exited_to_menu.connect(_on_game_exited_to_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and visible:
			SignalBus.game_started.emit(level_uid, &"")


func _on_game_exited_to_menu() -> void:
	show()


func _on_settings_button_pressed() -> void:
	SignalBus.settings_requested.emit(self)
