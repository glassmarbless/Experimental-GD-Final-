extends Area3D

@export var door_group_name: String = "button_door"

func interact() -> void:
	get_tree().call_group(door_group_name, "toggle_door")
