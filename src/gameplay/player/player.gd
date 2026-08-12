class_name Player
extends CharacterBody2D

@export var flying_speed: float = 200
@export var fall_speed: float = 300

var _is_dead: bool = false


func _physics_process(delta: float) -> void:
	var vertical_speed := 0.0

	if Input.is_action_pressed("fly") and not _is_dead:
		vertical_speed = -flying_speed
	elif not is_on_floor():
		vertical_speed = fall_speed
	elif _is_dead and is_on_floor():
		SignalBus.player_died.emit()

	velocity.y = move_toward(velocity.y, vertical_speed, get_gravity().y * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()


func die() -> void:
	_is_dead = true
