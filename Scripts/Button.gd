extends Area3D

@export var target_door: Node
@export var unlock_all_spells := true

func interact() -> void:
	if unlock_all_spells:
		SpellManager.discover_all_spells()

	if target_door:
		target_door.toggle_door()
	else:
		print("No target door linked")
