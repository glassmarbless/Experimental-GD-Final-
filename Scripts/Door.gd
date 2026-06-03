extends Node3D

var is_open := false

func toggle_door() -> void:
	is_open = !is_open

	# Hide/show all visible 3D model parts
	for model_part in find_children("*", "VisualInstance3D", true, false):
		model_part.visible = !is_open

	# Enable/disable all collision shapes
	for collision in find_children("*", "CollisionShape3D", true, false):
		collision.disabled = is_open
