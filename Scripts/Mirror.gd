extends StaticBody2D

@export var rotation_step_degrees := 45.0

func _ready():
	add_to_group("mirror")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		rotation_degrees += rotation_step_degrees
		
		var light = get_tree().get_first_node_in_group("light_source")
		if light:
			light.update_light()
