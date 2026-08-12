class_name Hazard
extends Area2D

signal despawned

const BLOCK_SIZE: float = 16

enum HazardType { HORIZONTAL, VERTICAL, DIAGONAL_UP, DIAGONAL_DOWN }

@export var length: int = 1
@export var type: HazardType = HazardType.HORIZONTAL
@export var rotating: bool = false
@export var speed: float = 50
@export var max_speed: float = 200
@export var hazard_block_scene: PackedScene

@onready var blocks: Node2D = %Blocks
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if length <= 0:
		push_error("Hazard length cannot be less than or equal to 0")
		return

	_build_hazard()
	speed = min(speed, max_speed)

	body_entered.connect(_on_body_entered)

	var timer := Timer.new()
	timer.wait_time = (get_viewport_rect().size.x / 1.5 + BLOCK_SIZE * length) / speed
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)


func _physics_process(delta: float) -> void:
	if rotating:
		rotation += delta

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
			offset -= 8
		blocks.add_child(_create_block(offset, 1))
		blocks.add_child(_create_block(offset, -1))
		pair_num += 1

	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(BLOCK_SIZE * length, BLOCK_SIZE)
	collision_shape.shape = rectangle

	if type == HazardType.VERTICAL:
		rotation_degrees = 90
	elif type == HazardType.DIAGONAL_UP:
		rotation_degrees = -45
	elif type == HazardType.DIAGONAL_DOWN:
		rotation_degrees = 45


func _create_block(offset: float, side: int) -> Sprite2D:
	var block := hazard_block_scene.instantiate() as Sprite2D
	block.global_position.x = offset * side
	return block


func _on_body_entered(_body: Node2D) -> void:
	var player := _body as Player
	player.die()


func _on_timer_timeout() -> void:
	despawned.emit()
	queue_free()
