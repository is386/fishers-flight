extends TextureButton

enum Channel {
	MUSIC,
	SFX,
}

## Which audio channel this button mutes and unmutes.
@export var channel: Channel = Channel.MUSIC

## Each channel is drawn by a pair of buttons stacked in the same slot: one
## showing the normal icon, one showing the crossed-out icon. This marks the
## crossed-out half, and only the half matching the current state is visible.
@export var shows_muted_icon: bool = false

## The toggles are only offered from a menu, so both halves stay hidden once a
## level is running. The title screen is already up when the HUD is built.
var _in_menu: bool = true
var _muted: bool = false


func _ready() -> void:
	pressed.connect(_on_pressed)

	SignalBus.game_paused.connect(_on_menu_entered)
	SignalBus.level_loaded.connect(_on_menu_exited)
	SignalBus.game_resume_requested.connect(_on_menu_exited)
	SignalBus.player_died.connect(_on_menu_exited)

	if channel == Channel.MUSIC:
		SignalBus.music_mute_changed.connect(_on_mute_changed)
		_muted = AudioBus.force_music_off
	else:
		SignalBus.sfx_mute_changed.connect(_on_mute_changed)
		_muted = AudioBus.force_sfx_off

	_refresh()


func _on_pressed() -> void:
	if channel == Channel.MUSIC:
		AudioBus.set_music_muted(not AudioBus.force_music_off)
	else:
		AudioBus.set_sfx_muted(not AudioBus.force_sfx_off)


func _on_mute_changed(muted: bool) -> void:
	_muted = muted
	_refresh()


func _on_menu_entered() -> void:
	_in_menu = true
	_refresh()


func _on_menu_exited() -> void:
	_in_menu = false
	_refresh()


func _refresh() -> void:
	visible = _in_menu and _muted == shows_muted_icon
