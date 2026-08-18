class_name Barrel
extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer

var _is_dead: bool = false
var _distance_covered: float = 0
var _speed: float = 100


func _physics_process(delta: float) -> void:
	if not _is_dead:
		return

	global_position.y -= _speed * delta
	_distance_covered += _speed * delta
	if _distance_covered >= 75:
		_speed = -100


func start() -> void:
	animator.play("walking")


func stop() -> void:
	animator.play("RESET")


func die() -> void:
	_is_dead = true
	animator.play("death")
