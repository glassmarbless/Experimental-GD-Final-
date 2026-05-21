extends Node2D

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_slot_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
