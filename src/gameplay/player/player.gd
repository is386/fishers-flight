class_name Player
extends CharacterBody2D

@export var flying_speed: float = 200
@export var fall_speed: float = 300

@onready var particles: CPUParticles2D = $CPUParticles2D

var _is_dying: bool = false
var _is_dead: bool = false


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	var vertical_speed := 0.0

	if Input.is_action_pressed("fly") and not _is_dying:
		vertical_speed = -flying_speed
		particles.emitting = true
	elif not is_on_floor():
		vertical_speed = fall_speed
		particles.emitting = false
	elif _is_dying and is_on_floor():
		SignalBus.player_died.emit()
		particles.emitting = false
		_is_dead = true

	velocity.y = move_toward(velocity.y, vertical_speed, get_gravity().y * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()


func die() -> void:
	_is_dying = true
