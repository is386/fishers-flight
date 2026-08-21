class_name Player
extends CharacterBody2D

@export var flying_speed: float = 200
@export var fall_speed: float = 300

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var walking_particles: CPUParticles2D = $WalkingParticles
@onready var landing_particles: CPUParticles2D = $LandingParticles
@onready var sliding_particles: CPUParticles2D = $SlidingParticles
@onready var barrel: Barrel = $Barrel

var _game_manager: GameManager
var _is_dead: bool = false
var _is_death_emitted: bool = false
var _was_on_floor: bool = false


func _ready() -> void:
	_game_manager = get_tree().get_first_node_in_group("game_manager")


func _physics_process(delta: float) -> void:
	if _is_dead:
		walking_particles.emitting = false

		if is_on_floor():
			sliding_particles.emitting = _game_manager.speed != 0
			if not _is_death_emitted:
				SignalBus.player_died.emit()
				_is_death_emitted = true
			return

		if not is_on_floor() and is_equal_approx(velocity.y, 0) and not animator.current_animation == "death":
			animator.play("death")

		if velocity.y < 0:
			velocity.y = move_toward(velocity.y, 0, get_gravity().y / 3 * delta)
		else:
			velocity.y = move_toward(velocity.y, fall_speed, get_gravity().y * delta)
		move_and_slide()

		return

	var vertical_speed := 0.0

	landing_particles.emitting = not _was_on_floor and is_on_floor()

	if not is_on_floor():
		walking_particles.emitting = false
		barrel.stop()

	if Input.is_action_pressed("fly"):
		vertical_speed = -flying_speed
		barrel.particles.emitting = true
		sprite.play("flying")
	elif not is_on_floor():
		vertical_speed = fall_speed
		barrel.particles.emitting = false
		sprite.play("falling")
	elif is_on_floor():
		sprite.play("walking")
		barrel.start()
		walking_particles.emitting = true

	_was_on_floor = is_on_floor()

	velocity.y = move_toward(velocity.y, vertical_speed, get_gravity().y * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()


func _play_death_animation() -> void:
	if is_on_floor():
		animator.play("death_ground")
		return

	animator.play("death_air")


func die() -> void:
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.1, true, false, true).timeout
	Engine.time_scale = 1.0

	_is_dead = true
	_play_death_animation()
	velocity.y = -flying_speed
	collision_layer = 0
	barrel.particles.emitting = false
	barrel.die()
	barrel.reparent(get_tree().current_scene.get_node("World/EntityRoot"))
