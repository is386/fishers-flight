extends Control

@export var game_manager: GameManager

@onready var score_label: Label = %ScoreLabel
@onready var restart_button: Button = %RestartButton
@onready var exit_to_menu_button: Button = %ExitToMenuButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_to_menu_button.pressed.connect(_on_exit_to_menu_button_pressed)
	visibility_changed.connect(_on_visibility_changed)
	SignalBus.player_died.connect(_on_player_died)


func _on_visibility_changed() -> void:
	if visible and is_inside_tree():
		restart_button.grab_focus.call_deferred()


func _on_restart_button_pressed() -> void:
	SignalBus.game_restart_requested.emit()


func _on_exit_to_menu_button_pressed() -> void:
	SignalBus.game_exit_to_title_requested.emit()


func _on_player_died() -> void:
	show()
	score_label.text = "%04d" % game_manager.distance
