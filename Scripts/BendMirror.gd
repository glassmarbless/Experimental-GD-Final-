extends StaticBody2D

@export var rotation_step := 90.0

func _ready():
	add_to_group("bend_mirror")
	input_pickable = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		rotation_degrees += rotation_step
		
		var puzzle = get_tree().get_first_node_in_group("light_puzzle")
		if puzzle:
			puzzle.update_beam()
