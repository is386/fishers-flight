extends Node

const MASTER_BUS: StringName = &"Master"
const MUSIC_BUS: StringName = &"Music"
const SFX_BUS: StringName = &"SFX"

const SFX_POOL_SIZE: int = 8

const MUSIC_VOLUME_DB: float = -2.5

var _sfx_players: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer = null
var _music_loops: bool = true
var force_music_off: bool = false
var force_sfx_off: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_music_player = _create_player(MUSIC_BUS)
	_music_player.volume_db = MUSIC_VOLUME_DB
	_music_player.finished.connect(_on_music_finished)

	for _i: int in SFX_POOL_SIZE:
		_sfx_players.append(_create_player(SFX_BUS))


func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null or force_sfx_off:
		return

	for _sfx_player: AudioStreamPlayer in _sfx_players:
		if not _sfx_player.playing:
			_sfx_player.stream = stream
			_sfx_player.volume_db = volume_db
			_sfx_player.play()
			return


func play_music(stream: AudioStream, loop: bool = true) -> void:
	if stream == null or force_music_off:
		return

	_music_loops = loop

	if _music_player.stream == stream and _music_player.playing:
		return

	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


func set_music_muted(muted: bool) -> void:
	if force_music_off == muted:
		return

	force_music_off = muted

	if muted:
		_music_player.stop()
	elif _music_player.stream != null:
		_music_player.play()

	SignalBus.music_mute_changed.emit(muted)


func set_sfx_muted(muted: bool) -> void:
	if force_sfx_off == muted:
		return

	force_sfx_off = muted

	if muted:
		for _sfx_player: AudioStreamPlayer in _sfx_players:
			_sfx_player.stop()

	SignalBus.sfx_mute_changed.emit(muted)


func set_master_volume(linear_volume: float) -> void:
	_set_bus_volume(MASTER_BUS, linear_volume)


func set_music_volume(linear_volume: float) -> void:
	_set_bus_volume(MUSIC_BUS, linear_volume)


func set_sfx_volume(linear_volume: float) -> void:
	_set_bus_volume(SFX_BUS, linear_volume)


func _on_music_finished() -> void:
	if _music_loops and not force_music_off:
		_music_player.play()


func _set_bus_volume(bus_name: StringName, linear_volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_error("Audio bus '%s' is missing from the bus layout" % bus_name)
		return

	var volume: float = clampf(linear_volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

	AudioServer.set_bus_mute(bus_index, is_zero_approx(volume))


func _create_player(bus_name: StringName) -> AudioStreamPlayer:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.bus = bus_name
	add_child(player)
	return player
