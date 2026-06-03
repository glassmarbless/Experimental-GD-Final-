extends Node

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
