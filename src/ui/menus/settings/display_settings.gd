extends VBoxContainer

@onready var fullscreen_toggle: CheckButton = %FullscreenToggle


func _ready() -> void:
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	fullscreen_toggle.set_pressed_no_signal(_is_fullscreen())

	SignalBus.settings_requested.connect(_on_settings_requested)


func _on_settings_requested(_callback_control: Control) -> void:
	fullscreen_toggle.set_pressed_no_signal(_is_fullscreen())


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	var mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED
	if toggled_on:
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN

	DisplayServer.window_set_mode(mode)


func _is_fullscreen() -> bool:
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return true

	return mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
