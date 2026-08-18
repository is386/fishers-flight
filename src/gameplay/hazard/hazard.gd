class_name Hazard
extends Area2D

signal despawned

enum HazardType { HORIZONTAL, VERTICAL, DIAGONAL_UP, DIAGONAL_DOWN }

@export var length: int = 1
@export var type: HazardType = HazardType.HORIZONTAL
@export var rotating: bool = false
@export var speed: float = 50
@export var max_speed: float = 200
@export var head_texture: AtlasTexture
@export var body_texture: AtlasTexture
@export var tail_texture: AtlasTexture

@onready var blocks: Node2D = %Blocks
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var despawn_timer: Timer = $DespawnTimer

var block_size: float = 21
var _blocks: Array[Sprite2D]
var _current_block: int = 0
var _time: float = 0


func _ready() -> void:
	if length <= 1:
		push_error("Hazard length cannot be less than or equal to 1")
		return

	_build_hazard()
	speed = min(speed, max_speed)

	body_entered.connect(_on_body_entered)

	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start((get_viewport_rect().size.x / 1.5 + block_size * length) / speed)


func _physics_process(delta: float) -> void:
	if rotating:
		rotation -= delta

	global_position.x -= speed * delta

	_time += delta
	if _time >= 0.15:
		var next_block := _current_block + 1
		if next_block == length:
			next_block = 0
		_blocks[next_block].offset.y = -1
		_blocks[_current_block].offset.y = 0
		_current_block = next_block
		_time = 0


func _build_hazard() -> void:
	var is_even := length % 2 == 0
	var starting_index := 0

	if not is_even:
		blocks.add_child(_create_block(0, 1, 0))
		starting_index = 2

	var pair_num := 1
	for i in range(starting_index, length, 2):
		var offset := pair_num * block_size
		if is_even:
			offset -= block_size / 2
		var is_head_or_tail := i + 2 >= length
		blocks.add_child(_create_block(offset, 1, is_head_or_tail))
		blocks.add_child(_create_block(offset, -1, is_head_or_tail))
		pair_num += 1

	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(block_size * (length - 1), block_size)
	collision_shape.shape = rectangle

	if type == HazardType.VERTICAL:
		rotation_degrees = 90
		_blocks.sort_custom(_sort_blocks_y)
	elif type == HazardType.HORIZONTAL:
		_blocks.sort_custom(_sort_blocks_x)
	elif type == HazardType.DIAGONAL_UP:
		rotation_degrees = -45
		_blocks.sort_custom(_sort_blocks_x)
	elif type == HazardType.DIAGONAL_DOWN:
		rotation_degrees = 45
		_blocks.sort_custom(_sort_blocks_x)


func _sort_blocks_x(a: Sprite2D, b: Sprite2D) -> bool:
	return a.global_position.x <= b.global_position.x


func _sort_blocks_y(a: Sprite2D, b: Sprite2D) -> bool:
	return a.global_position.y <= b.global_position.y


func _create_block(offset: float, side: int, is_head_or_tail: bool) -> Sprite2D:
	var block := Sprite2D.new()
	_blocks.append(block)

	if is_head_or_tail:
		if side == -1:
			block.texture = head_texture
		else:
			block.texture = tail_texture
	else:
		block.texture = body_texture
	block.global_position.x = offset * side
	return block


func _on_body_entered(_body: Node2D) -> void:
	var player := _body as Player
	player.die()


func _on_despawn_timer_timeout() -> void:
	despawned.emit()
	queue_free()
