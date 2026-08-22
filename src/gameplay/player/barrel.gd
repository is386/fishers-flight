class_name Barrel
extends Node2D

@export var fly_speed: float = 100
@export var fall_speed: float = 100
@export var acceleration: float = 50
@export var deceleration: float = 50

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var jetpack_audio: AudioStreamPlayer = $JetpackAudio

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


func _ready() -> void:
	SignalBus.sfx_mute_changed.connect(_on_sfx_mute_changed)


## The jetpack loop drives its own player rather than going through
## AudioBus.play_sfx, so it has to honour the mute flag itself.
func set_jetpack_playing(is_playing: bool) -> void:
	var should_play: bool = is_playing and not AudioBus.force_sfx_off

	if should_play == jetpack_audio.playing:
		return

	if should_play:
		jetpack_audio.play()
	else:
		jetpack_audio.stop()


## Muting happens from the pause menu, where the player has stopped driving
## set_jetpack_playing, so an already looping jetpack has to be cut here.
func _on_sfx_mute_changed(muted: bool) -> void:
	if muted:
		jetpack_audio.stop()


func die() -> void:
	set_jetpack_playing(false)
	_is_dead = true
	animator.play("death")
	_speed = -fly_speed
