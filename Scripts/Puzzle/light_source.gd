extends Node2D

@export var direction := Vector2.RIGHT
@export var max_bounces := 10
@export var required_reflections := 3
@export var ray_length := 2000.0

var reflections := 0

func _ready():
	add_to_group("light_source")
	update_light()

func update_light():
	reflections = 0
	
	var start_pos = global_position
	var dir = direction.normalized()
	
	for i in range(max_bounces):
		var space = get_world_2d().direct_space_state
		
		var query = PhysicsRayQueryParameters2D.create(
			start_pos,
			start_pos + dir * ray_length
		)
		
		var result = space.intersect_ray(query)
		
		if result.is_empty():
			break
		
		var hit_object = result.collider
		
		if hit_object.is_in_group("mirror"):
			reflections += 1
			dir = dir.bounce(result.normal)
			start_pos = result.position + dir * 2.0
		
		elif hit_object.is_in_group("target"):
			hit_object.check_success(reflections, required_reflections)
			break
		
		else:
			break
