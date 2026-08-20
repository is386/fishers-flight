class_name ShakingCamera
extends Camera2D

@onready var shaking_component: ShakingComponent = $ShakingComponent


func _ready() -> void:
	SignalBus.camera_shake_requested.connect(screen_shake)


func screen_shake(intensity: float, time: float) -> void:
	shaking_component.shake(intensity, time)
