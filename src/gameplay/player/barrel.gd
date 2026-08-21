class_name Barrel
extends Node2D

@export var fly_speed: float = 100
@export var fall_speed: float = 100
@export var acceleration: float = 50
@export var deceleration: float = 50

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D

var _speed: float = 0
var _is_falling: bool = false
var _is_dead: bool = false


func _physics_process(delta: float) -> void:
	if not _is_dead:
		return

	if not _is_falling:
		_speed = move_toward(_speed, 0, acceleration * delta)
	else:
		_speed = move_toward(_speed, fall_speed, deceleration * delta)

	global_position.y += _speed * delta

	if is_equal_approx(_speed, 0):
		_is_falling = true


func start() -> void:
	animator.play("walking")


func stop() -> void:
	animator.play("RESET")


func die() -> void:
	_is_dead = true
	animator.play("death")
	_speed = -fly_speed
