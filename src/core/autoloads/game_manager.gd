class_name GameManager
extends Node

var distance: float = 0
var _is_started: bool


func _ready() -> void:
	SignalBus.level_loaded.connect(_on_level_loaded)


func _physics_process(_delta: float) -> void:
	if not _is_started:
		return
	distance += 0.2


func _on_level_loaded() -> void:
	_is_started = true
