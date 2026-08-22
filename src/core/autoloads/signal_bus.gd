extends Node

@warning_ignore_start("unused_signal")

signal game_started
signal game_restart_requested
signal game_pause_requested
signal game_paused
signal game_resume_requested

signal level_loaded

signal milestone_reached
signal high_score_achieved

signal player_died

signal camera_shake_requested(intensity: float, time: float)
