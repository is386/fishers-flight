extends VBoxContainer

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SfxSlider


func _ready() -> void:
	master_slider.value_changed.connect(AudioBus.set_master_volume)
	music_slider.value_changed.connect(AudioBus.set_music_volume)
	sfx_slider.value_changed.connect(AudioBus.set_sfx_volume)
