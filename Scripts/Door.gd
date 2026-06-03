extends Node3D

@export var door_name := "door_1"

signal door_opened(door_name: String)
var is_open := false

func toggle_door() -> void:
	is_open = !is_open
	door_opened.emit(door_name)

	# Hide/show all visible 3D model parts
	for model_part in find_children("*", "VisualInstance3D", true, false):
		model_part.visible = !is_open

	# Enable/disable all collision shapes
	for collision in find_children("*", "CollisionShape3D", true, false):
		collision.disabled = is_open

func force_open_from_save():
	is_open = true
	toggle_door()
