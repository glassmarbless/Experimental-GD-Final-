extends Node

const SETTINGS_PATH := "user://settings.cfg"

var resolution: Vector2i = Vector2i(1920, 1080)
var fullscreen: bool = false

var master_volume: float = 100.0
var music_volume: float = 100.0
var soundfx_volume: float = 100.0


func _ready() -> void:
	load_settings()
	apply_settings()


func save_settings() -> void:
	var config := ConfigFile.new()

	config.set_value("display", "resolution_x", resolution.x)
	config.set_value("display", "resolution_y", resolution.y)
	config.set_value("display", "fullscreen", fullscreen)

	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "soundfx_volume", soundfx_volume)

	config.save(SETTINGS_PATH)


func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)

	if err != OK:
		return

	resolution = Vector2i(
		int(config.get_value("display", "resolution_x", 1920)),
		int(config.get_value("display", "resolution_y", 1080))
	)

	fullscreen = bool(config.get_value("display", "fullscreen", false))

	master_volume = float(config.get_value("audio", "master_volume", 100.0))
	music_volume = float(config.get_value("audio", "music_volume", 100.0))
	soundfx_volume = float(config.get_value("audio", "soundfx_volume", 100.0))


func apply_settings() -> void:
	apply_display_settings()
	apply_audio_settings()


func apply_display_settings() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)
		center_window()


func apply_audio_settings() -> void:
	apply_volume("Master", master_volume)
	apply_volume("Music", music_volume)
	apply_volume("SoundFX", soundfx_volume)


func apply_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		print("Audio bus not found: ", bus_name)
		return

	if value <= 0:
		AudioServer.set_bus_volume_db(bus_index, -80)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))


func center_window() -> void:
	var screen_size := DisplayServer.screen_get_size()
	var window_size := DisplayServer.window_get_size()
	var new_position := (screen_size - window_size) / 2

	DisplayServer.window_set_position(new_position)
