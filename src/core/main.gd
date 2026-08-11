class_name MainGame
extends Node

const PLAYER_SCENE_UID: String = "uid://bk2cu2ameptuy"

var player: Player = null

@onready var level_manager: LevelManager = %LevelManager
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot
@onready var menu_layer: CanvasLayer = %MenuLayer


func _ready() -> void:
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_exit_to_title_requested.connect(_exit_to_title)
	SignalBus.game_close_requested.connect(_close_game)
	SignalBus.game_pause_requested.connect(_pause_game)
	SignalBus.game_resume_requested.connect(_resume_game)


func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("debug_quit"):
		_close_game()


func _pause_game() -> void:
	if get_tree().paused or level_manager.current_level == null:
		return

	get_tree().paused = true
	SignalBus.game_paused.emit()


func _resume_game() -> void:
	if not get_tree().paused:
		return

	get_tree().paused = false
	SignalBus.game_resumed.emit()


func _start_game(level_uid: String, spawn_id: StringName) -> void:
	if level_uid.is_empty():
		push_error("Cannot start the game without a level")
		return

	_hide_menus()
	_init_player()
	_load_level(level_uid, spawn_id)
	player.show()


func _exit_to_title() -> void:
	get_tree().paused = false

	_hide_menus()
	_clear_world()

	await get_tree().process_frame

	SignalBus.game_exited_to_menu.emit()


func _close_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _clear_world() -> void:
	for root: Node2D in [entity_root, effect_root]:
		for child: Node in root.get_children():
			child.queue_free()

	player = null


func _hide_menus() -> void:
	for root: Node in menu_layer.get_children():
		for menu: Node in root.get_children():
			if menu is CanvasItem:
				(menu as CanvasItem).hide()


func _load_level(level_scene: String, spawn_id: StringName = &"") -> BaseLevel:
	var level: BaseLevel = await level_manager.load_level(level_scene)
	if level == null:
		return null

	_place_player_at_level_spawn(spawn_id)

	SignalBus.level_loaded.emit(level)
	return level


func _init_player() -> void:
	if player != null:
		return

	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return

	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
		return

	player.hide()
	entity_root.add_child(player)


func _place_player_at_level_spawn(spawn_id: StringName) -> void:
	if player == null:
		return
	if level_manager.current_level == null:
		push_error("Cannot place player into level because level is null")
		return

	player.global_position = level_manager.current_level.get_spawn_point(spawn_id)
