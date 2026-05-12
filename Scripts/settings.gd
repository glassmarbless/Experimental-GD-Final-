extends Node2D

@onready var slider = $"Control/Settings Holder/Volume Holder/Slider Holder/Volume Adjust"
@onready var resolution_button = $"Control/Settings Holder/Resolution Holder/Resolution Button"
@onready var fullscreen_button = $"Control/Settings Holder/Fullscreen Holder/HBoxContainer/Fullscreen Button"

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

	# Set default displayed option to 1920 x 1080
	var default_index = resolutions.keys().find("1920 x 1080")
	resolution_button.select(default_index)

	resolution_button.item_selected.connect(_on_resolution_selected)
	fullscreen_button.toggled.connect(_on_fullscreen_toggled)

	# Apply default resolution when game starts
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(current_resolution)
	center_window()


func _on_resolution_selected(index: int):
	var selected_text = resolution_button.get_item_text(index)
	current_resolution = resolutions[selected_text]

	if is_fullscreen:
		# Stay fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Only resize window in windowed mode
		DisplayServer.window_set_size(current_resolution)
		center_window()


func _on_fullscreen_toggled(button_pressed: bool):
	is_fullscreen = button_pressed

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(current_resolution)
		center_window()


func center_window():
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)


func _on_volume_adjust_value_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_volume_db(0, -80)
	else:
		AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
