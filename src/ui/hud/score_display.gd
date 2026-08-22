extends Control

@export var game_manager: GameManager

@onready var distance_label: Label = %Distance


func _ready() -> void:
	SignalBus.level_loaded.connect(show)
	SignalBus.player_died.connect(hide)


func _process(_delta: float) -> void:
	distance_label.text = "%04d" % game_manager.distance
