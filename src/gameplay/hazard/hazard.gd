class_name Hazard
extends Area2D

const BLOCK_SIZE: float = 16

enum HazardType { HORIZONTAL, VERTICAL, DIAGONAL_UP, DIAGONAL_DOWN }

@export var length: int = 1
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
	var is_even := length % 2 == 0
	var starting_index := 0

	if not is_even:
		blocks.add_child(_create_block(0, 1))
		starting_index = 2

	var pair_num := 1
	for i in range(starting_index, length, 2):
		var offset := pair_num * BLOCK_SIZE
		if is_even:
			offset -= 8
		blocks.add_child(_create_block(offset, 1))
		blocks.add_child(_create_block(offset, -1))
		pair_num += 1

	var rectangle := RectangleShape2D.new()
	var hazard_size := BLOCK_SIZE * length
	var diagonal_block_size := sqrt(pow(BLOCK_SIZE, 2) * 2)

	if type == HazardType.HORIZONTAL:
		rectangle.size = Vector2(hazard_size, BLOCK_SIZE)
	elif type == HazardType.VERTICAL:
		rectangle.size = Vector2(BLOCK_SIZE, hazard_size)
	elif type == HazardType.DIAGONAL_UP:
		collision_shape.rotation_degrees = -45
		rectangle.size = Vector2(diagonal_block_size * length, BLOCK_SIZE)
	elif type == HazardType.DIAGONAL_DOWN:
		collision_shape.rotation_degrees = 45
		rectangle.size = Vector2(diagonal_block_size * length, BLOCK_SIZE)

	collision_shape.shape = rectangle
	body_entered.connect(_on_body_entered)


func _create_block(offset: float, side: int) -> Sprite2D:
	var block := hazard_block_scene.instantiate() as Sprite2D

	var block_position := offset * side
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

	return block


func _on_body_entered(_body: Node2D) -> void:
	print("player entered")
