extends Node

@export var level_scene: PackedScene
@export var player_scene: PackedScene

var level: BaseLevel = null
var player: Player = null

@onready var game_manager: GameManager = %GameManager
@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot


func _ready() -> void:
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_restart_requested.connect(_restart_game)
	SignalBus.game_pause_requested.connect(_pause_game)
	SignalBus.game_resume_requested.connect(_resume_game)
	_build_world()


func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("debug_quit"):
		get_tree().quit()


func _start_game() -> void:
	game_manager.reset()
	SignalBus.level_loaded.emit()


func _restart_game() -> void:
	get_tree().paused = false
	_build_world()
	_start_game()


func _pause_game() -> void:
	if get_tree().paused:
		return

	get_tree().paused = true
	SignalBus.game_paused.emit()


func _resume_game() -> void:
	get_tree().paused = false


func _build_world() -> void:
	for root: Node2D in [level_root, entity_root, effect_root]:
		for child: Node in root.get_children():
			child.free()

	level = level_scene.instantiate() as BaseLevel
	level_root.add_child(level)

	player = player_scene.instantiate() as Player
	entity_root.add_child(player)
	player.global_position = level.spawn_position
