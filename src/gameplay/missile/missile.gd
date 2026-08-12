class_name Missile
extends Area2D

@export var speed: float = 200

@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visibility_notifier.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta


func _on_body_entered(_body: Node2D) -> void:
	var player := _body as Player
	player.die()


func _on_screen_exited() -> void:
	queue_free()
