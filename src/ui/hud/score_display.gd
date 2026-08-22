extends Control

@export var game_manager: GameManager

@onready var distance_label: Label = %Distance


func _ready() -> void:
	SignalBus.level_loaded.connect(show)


func _process(_delta: float) -> void:
	distance_label.text = "%05d" % game_manager.distance
