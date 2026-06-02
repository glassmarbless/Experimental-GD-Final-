extends Node2D

@export var required_reflections := 1
@export var max_bounces := 10

@onready var light_source = $LightSource
@onready var beam_line = $BeamLine

func _ready():
	update_beam()

func update_beam():
	var points: Array[Vector2] = []
	var start_pos = light_source.global_position
	var dir = Vector2.RIGHT
	var reflections = 0

	points.append(start_pos)

	for i in range(max_bounces):
		var space = get_world_2d().direct_space_state

		var query = PhysicsRayQueryParameters2D.create(
			start_pos,
			start_pos + dir * 2000
		)

		var result = space.intersect_ray(query)

		if result.is_empty():
			points.append(start_pos + dir * 2000)
			break

		points.append(result.position)

		var hit = result.collider

		if hit.is_in_group("mirror"):
			reflections += 1
			dir = dir.bounce(result.normal)
			start_pos = result.position + dir * 2

		elif hit.is_in_group("target"):
			if reflections == required_reflections:
				print("Puzzle solved!")
			else:
				print("Wrong number of reflections: ", reflections)
			break

		else:
			break

	beam_line.points = points
	

func _on_button_button_down() -> void:
	queue_free()
