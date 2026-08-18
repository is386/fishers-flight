class_name Player
extends CharacterBody2D

@export var flying_speed: float = 200
@export var fall_speed: float = 300

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var fisherman_sprite: AnimatedSprite2D = $FishermanAnimatedSprite2D
@onready var barrel_animator: AnimationPlayer = $BarrelAnimationPlayer

var _is_dying: bool = false
var _is_dead: bool = false


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	var vertical_speed := 0.0

	if not is_on_floor():
		barrel_animator.play("RESET")

	if Input.is_action_pressed("fly") and not _is_dying:
		vertical_speed = -flying_speed
		particles.emitting = true
		fisherman_sprite.play("flying")
	elif not is_on_floor():
		vertical_speed = fall_speed
		particles.emitting = false
		fisherman_sprite.play("falling")
	elif _is_dying and is_on_floor():
		SignalBus.player_died.emit()
		particles.emitting = false
		_is_dead = true
	elif is_on_floor():
		fisherman_sprite.play("walking")
		barrel_animator.play("walking")

	velocity.y = move_toward(velocity.y, vertical_speed, get_gravity().y * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()


func die() -> void:
	_is_dying = true
