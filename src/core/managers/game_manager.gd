class_name GameManager
extends Node

var distance: float
var high_score: float
var speed: float
var milestone: float
var _is_running: bool
var _distance_increment: float
var _speed_increment: float
var _high_score_achieved: bool


func _ready() -> void:
	SignalBus.level_loaded.connect(_on_level_loaded)
	SignalBus.player_died.connect(_on_player_died)
	reset()


func reset() -> void:
	distance = 0
	speed = 0
	milestone = 1000
	_is_running = false
	_distance_increment = 0.3
	_speed_increment = 0.006
	_high_score_achieved = false


func _physics_process(_delta: float) -> void:
	if not _is_running:
		speed = max(0, speed - 1)
		return

	distance += _distance_increment
	speed += _speed_increment

	if high_score > 0 and distance > high_score and not _high_score_achieved:
		_high_score_achieved = true
		SignalBus.high_score_achieved.emit()

	if distance > milestone and milestone <= 5000:
		milestone += 1000
		_distance_increment *= 1.5
		_speed_increment *= 1.5
		SignalBus.milestone_reached.emit()


func _on_level_loaded() -> void:
	_is_running = true
	speed = 100


func _on_player_died() -> void:
	_is_running = false
	if distance > high_score:
		high_score = distance
