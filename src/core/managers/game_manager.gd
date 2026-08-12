class_name GameManager
extends Node

var distance: float = 0
var milestone: float = 1000
var _is_started: bool
var _distance_increment: float = 0.2


func _ready() -> void:
	SignalBus.level_loaded.connect(_on_level_loaded)
	SignalBus.player_died.connect(_on_player_died)


func _physics_process(_delta: float) -> void:
	if not _is_started:
		return

	distance += _distance_increment

	if distance > milestone and milestone <= 5000:
		milestone += 1000
		_distance_increment *= 1.5
		SignalBus.milestone_reached.emit()


func _on_level_loaded() -> void:
	_is_started = true


func _on_player_died() -> void:
	_is_started = false
