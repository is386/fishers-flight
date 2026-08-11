class_name Hazard
extends Area2D

enum HazardType { HORIZONTAL, VERTICAL, DIAGONAL_UP, DIAGONAL_DOWN }

@export var length: float = 1
@export var type: HazardType = HazardType.HORIZONTAL
@export var hazard_block_scene: PackedScene

@onready var blocks: Node2D = %Blocks
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if length <= 0:
		push_error("Hazard length cannot be less than or equal to 0")
		return

	_build_hazard()


func _build_hazard() -> void:
	var block_size: float

	for i in range(length):
		var block := hazard_block_scene.instantiate() as Sprite2D
		block_size = block.texture.get_size().x

		var block_position := i * block_size
		if type == HazardType.HORIZONTAL:
			block.global_position.x = block_position
		elif type == HazardType.VERTICAL:
			block.global_position.y = block_position
		elif type == HazardType.DIAGONAL_UP:
			block.global_position.x = block_position
			block.global_position.y = -block_position
		elif type == HazardType.DIAGONAL_DOWN:
			block.global_position.x = block_position
			block.global_position.y = block_position

		blocks.add_child(block)

	var rectangle := RectangleShape2D.new()
	var hazard_offset := (length - 1) * block_size / 2
	var hazard_size := block_size * length
	var diagonal_block_size := sqrt(pow(block_size, 2) * 2)

	if type == HazardType.HORIZONTAL:
		global_position.x -= hazard_offset
		collision_shape.position.x += hazard_offset
		rectangle.size = Vector2(hazard_size, block_size)
	elif type == HazardType.VERTICAL:
		global_position.y -= hazard_offset
		collision_shape.position.y += hazard_offset
		rectangle.size = Vector2(block_size, hazard_size)
	elif type == HazardType.DIAGONAL_UP:
		global_position.x -= hazard_offset
		global_position.y += hazard_offset
		collision_shape.position.x += hazard_offset
		collision_shape.position.y -= hazard_offset
		collision_shape.rotation_degrees = -45
		rectangle.size = Vector2(diagonal_block_size * length, block_size)
	elif type == HazardType.DIAGONAL_DOWN:
		global_position.x -= hazard_offset
		global_position.y -= hazard_offset
		collision_shape.position.x += hazard_offset
		collision_shape.position.y += hazard_offset
		collision_shape.rotation_degrees = 45
		rectangle.size = Vector2(diagonal_block_size * length, block_size)

	collision_shape.shape = rectangle

	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	print("player entered")
