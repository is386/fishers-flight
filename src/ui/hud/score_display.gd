extends Control

@export var game_manager: GameManager

@onready var distance_label: Label = %Distance


func _ready() -> void:
	SignalBus.level_loaded.connect(_on_level_loaded)


func _process(_delta: float) -> void:
	distance_label.text = "%04d" % game_manager.distance


func _on_level_loaded() -> void:
	show()
