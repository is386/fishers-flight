class_name ShakingComponent
extends Node

## How fast the shake is sampled out of the noise field.
const SHAKE_TIME_SPEED := 20.0

## How fast a finished shake eases back to zero offset.
const RETURN_SPEED := 10.5

var _target: Node2D
var _offset := Vector2.ZERO
var _shake_intensity := 0.0
var _shake_decay := 5.0
var _active_shake_time := 0.0
var _shake_time := 0.0
var _only_shake_x := false
var _noise := FastNoiseLite.new()


func _ready() -> void:
	_target = get_parent() as Node2D
	if not (_target is Camera2D or _target is Sprite2D):
		push_error("ShakingComponent parent is not a Camera2D or Sprite2D")


func _physics_process(delta: float) -> void:
	if _active_shake_time <= 0.0:
		_offset = Vector2(
			lerpf(_offset.x, 0.0, RETURN_SPEED * delta),
			lerpf(_offset.y, 0.0, RETURN_SPEED * delta),
		)
	else:
		_shake_time += delta * SHAKE_TIME_SPEED
		_active_shake_time -= delta

		_offset = Vector2(
			_noise.get_noise_2d(_shake_time, 0.0) * _shake_intensity,
			_noise.get_noise_2d(0.0, _shake_time) * _shake_intensity,
		)
		_shake_intensity = maxf(_shake_intensity - _shake_decay * delta, 0.0)

	_set_offset()


func _set_offset() -> void:
	if _target is Camera2D or _target is Sprite2D:
		_target.offset = Vector2(_offset.x, 0.0) if _only_shake_x else _offset


func shake(intensity: float, time: float, only_shake_x := false) -> void:
	_noise.seed = randi()
	_noise.frequency = 2.0

	_shake_intensity = intensity
	_active_shake_time = time
	_shake_time = 0.0
	_only_shake_x = only_shake_x

	_shake_decay = intensity / time if time > 0.0 else 0.0
