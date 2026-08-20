class_name Missile
extends Area2D

@export var speed: float = 200
@export var explosion_scene: PackedScene

@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	visibility_notifier.screen_exited.connect(_on_screen_exited)
	body_entered.connect(_on_body_entered)
	particles.finished.connect(_on_particles_finished)


func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta


func _on_body_entered(_body: Node2D) -> void:
	var player := _body as Player
	player.die()

	particles.emitting = false
	sprite.hide()

	var explosion := explosion_scene.instantiate() as Node2D
	explosion.global_position = global_position
	explosion.global_position.x -= 24
	get_tree().current_scene.get_node("World/EffectRoot").add_child(explosion)

	SignalBus.camera_shake_requested.emit(10, 0.65)


func _on_screen_exited() -> void:
	particles.emitting = false


func _on_particles_finished() -> void:
	queue_free()
