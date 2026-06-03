extends Node2D

func _on_settings_button_pressed() -> void:
	SettingsManager.previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/save_slots.tscn")
