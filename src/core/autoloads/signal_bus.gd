extends Node

@warning_ignore_start("unused_signal")

signal game_started(level_uid: String, spawn_id: StringName)
signal game_restart_requested
signal game_exit_to_title_requested
signal game_exited_to_menu
signal game_close_requested
signal game_pause_requested
signal game_paused
signal game_resume_requested

signal settings_requested(return_to: Control)

signal level_loaded
signal level_unloading

signal milestone_reached

signal player_died

signal camera_shake_requested(intensity: float, time: float)
