extends Node2D

@onready var master_slider = $"Control/Settings Holder/Volume Holder/Slider Holder/Volume Adjust"
@onready var music_slider = $"Control/Settings Holder/Volume Holder2/Slider Holder/Music Adjust"
@onready var soundfx_slider = $"Control/Settings Holder/Volume Holder3/Slider Holder/Soundfx Adjust"
@onready var resolution_button = $"Control/Settings Holder/Resolution Holder/Resolution Button"
@onready var fullscreen_button = $"Control/Settings Holder/Fullscreen Holder/HBoxContainer/Fullscreen Button"

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var soundfx_bus = AudioServer.get_bus_index("Soundfx")

var resolutions := {
	"1280 x 720": Vector2i(1280, 720),
	"1600 x 900": Vector2i(1600, 900),
	"1920 x 1080": Vector2i(1920, 1080),
	"2560 x 1440": Vector2i(2560, 1440)
}

var current_resolution := Vector2i(1920, 1080)
var is_fullscreen := false


func _ready():
	resolution_button.clear()

	for r in resolutions.keys():
		resolution_button.add_item(r)

	fullscreen_button.button_pressed = SettingsManager.fullscreen
	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	soundfx_slider.value = SettingsManager.soundfx_volume

	var saved_res_text := "%d x %d" % [
		SettingsManager.resolution.x,
		SettingsManager.resolution.y
	]

	var index := resolutions.keys().find(saved_res_text)

	if index != -1:
		resolution_button.select(index)


func _on_resolution_selected(index: int):
	var text = resolution_button.get_item_text(index)

	SettingsManager.resolution = resolutions[text]
	SettingsManager.apply_settings()
	SettingsManager.save_settings()


func _on_fullscreen_toggled(button_pressed: bool):
	SettingsManager.fullscreen = button_pressed
	SettingsManager.apply_settings()
	SettingsManager.save_settings()


func center_window():
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)


func _on_volume_adjust_value_changed(value: float) -> void:
	SettingsManager.master_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	var current := str(int(SettingsManager.master_volume))
	$"Control/Settings Holder/Volume Holder/Slider Holder/max".text = current

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_music_adjust_value_changed(value: float) -> void:
	SettingsManager.music_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	var current := str(int(SettingsManager.music_volume))
	$"Control/Settings Holder/Volume Holder2/Slider Holder/max".text = current

func _on_soundfx_adjust_value_changed(value: float) -> void:
	SettingsManager.soundfx_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	var current := str(int(SettingsManager.soundfx_volume))
	$"Control/Settings Holder/Volume Holder3/Slider Holder/max".text = current
