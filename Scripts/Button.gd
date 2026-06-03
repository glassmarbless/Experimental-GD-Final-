extends Area3D

@export var target_door: Node

func interact() -> void:
	if target_door:
		target_door.toggle_door()
	else:
		print("No target door linked")
