class_name Hazard
extends Area2D

enum HazardType { HORIZONTAL, VERTICAL, DIAGONAL_UP, DIAGONAL_DOWN }

signal despawned

const BLOCK_SIZE = 12.0

@export var length: int = 1
@export var type: HazardType = HazardType.HORIZONTAL
@export var rotating: bool = false
@export var speed: float = 50
@export var max_speed: float = 200
@export var head_textures: Array[AtlasTexture]
@export var body_texture: AtlasTexture
@export var tail_textures: Array[AtlasTexture]

@onready var blocks: Node2D = %Blocks
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var despawn_timer: Timer = $DespawnTimer

var _blocks: Array[Sprite2D]


func _ready() -> void:
	var min_length := head_textures.size() + tail_textures.size()
	if length < min_length:
		push_error("Hazard length cannot be less than %d" % min_length)
		return

	_build_hazard()
	speed = min(speed, max_speed)

	body_entered.connect(_on_body_entered)

	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start((get_viewport_rect().size.x / 1.5 + BLOCK_SIZE * length * 2) / speed)


func _physics_process(delta: float) -> void:
	if rotating:
		rotation -= delta

	global_position.x -= speed * delta


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
			offset -= BLOCK_SIZE / 2
		blocks.add_child(_create_block(offset, 1))
		blocks.add_child(_create_block(offset, -1))
		pair_num += 1

	_blocks.sort_custom(_sort_blocks)

	for i in head_textures.size():
		_blocks[i].texture = head_textures[i]

	for i in tail_textures.size():
		_blocks[length - tail_textures.size() + i].texture = tail_textures[i]

	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(BLOCK_SIZE * (length - 1), BLOCK_SIZE)
	collision_shape.shape = rectangle

	if type == HazardType.VERTICAL:
		rotation_degrees = 90
	elif type == HazardType.DIAGONAL_UP:
		rotation_degrees = -45
	elif type == HazardType.DIAGONAL_DOWN:
		rotation_degrees = 45


func _sort_blocks(a: Sprite2D, b: Sprite2D) -> bool:
	return a.global_position.x <= b.global_position.x


func _create_block(offset: float, side: int) -> Sprite2D:
	var block := Sprite2D.new()
	_blocks.append(block)

	block.texture = body_texture
	block.global_position.x = offset * side
	return block


func _on_body_entered(_body: Node2D) -> void:
	var player := _body as Player
	player.die()


func _on_despawn_timer_timeout() -> void:
	despawned.emit()
	queue_free()
