extends Control

@export var game_manager: GameManager

@onready var distance_label: Label = %Distance
@onready var high_score_label: Label = %HighScore


func _ready() -> void:
	SignalBus.level_loaded.connect(_on_level_loaded)
	SignalBus.high_score_achieved.connect(_on_high_score)
	SignalBus.player_died.connect(_on_player_died)


func _process(_delta: float) -> void:
	distance_label.text = "%05d" % game_manager.distance


func _on_high_score() -> void:
	high_score_label.show()
	high_score_label.text = "NEW HI SCORE!"


func _on_level_loaded() -> void:
	show()
	if game_manager.high_score > 0:
		high_score_label.show()
	else:
		high_score_label.hide()
	high_score_label.text = "HI %05d" % game_manager.high_score


func _on_player_died() -> void:
	high_score_label.show()
	high_score_label.text = "HI %05d" % game_manager.high_score
