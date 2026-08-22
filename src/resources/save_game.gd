class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

@export var high_score := 0.0


func write_save() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)


static func load_save() -> SaveGame:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
