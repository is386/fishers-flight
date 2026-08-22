extends Control

@export var game_manager: GameManager

@onready var score_label: Label = %ScoreLabel
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	SignalBus.player_died.connect(_on_player_died)


func _on_restart_button_pressed() -> void:
	hide()
	SignalBus.game_restart_requested.emit()


func _on_player_died() -> void:
	score_label.text = "%04d" % game_manager.distance
	show()
