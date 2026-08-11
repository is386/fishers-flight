class_name Hazard
extends Area2D

@export var length: float = 1
@export var hazard_block_scene: PackedScene

@onready var blocks: Node2D = %Blocks
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if length <= 0:
		push_error("Hazard length cannot be less than or equal to 0")
		return

	var block_size: float

	for i in range(length):
		var block := hazard_block_scene.instantiate() as Sprite2D
		block_size = block.texture.get_size().x
		block.global_position.x = global_position.x + (i * block_size)
		blocks.add_child(block)

	global_position.x -= (length - 1) * block_size / 2
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(block_size * length, block_size)
	collision_shape.shape = rectangle
	collision_shape.position.x += (length - 1) * block_size / 2

	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	print("player entered")
