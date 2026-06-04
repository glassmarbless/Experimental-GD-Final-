extends Node2D

@export var required_reflections := 1
@export var max_bounces := 10

@onready var light_source = $LightSource
@onready var beam_line = $BeamLine

func _ready():
	add_to_group("light_puzzle")
	update_beam()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()

		var space = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_pos
		query.collide_with_bodies = true
		query.collide_with_areas = true

		var results = space.intersect_point(query)

		for result in results:
			var obj = result.collider

			if obj.is_in_group("mirror") or obj.is_in_group("bend_mirror"):
				obj.rotation_degrees += 90
				update_beam()
				return

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
		start_pos + dir * 2000)
		query.hit_from_inside = true
		query.collide_with_bodies = true
		query.collide_with_areas = true

		var result = space.intersect_ray(query)

		if result.is_empty():
			points.append(start_pos + dir * 2000)
			break

		points.append(result.position)

		var hit = result.collider

		if hit.is_in_group("mirror"):
			reflections += 1

			var mirror_surface_dir = Vector2.RIGHT.rotated(hit.global_rotation)
			var mirror_normal = mirror_surface_dir.rotated(PI / 2).normalized()

			if dir.dot(mirror_normal) > 0:
				mirror_normal = -mirror_normal

			dir = dir.bounce(mirror_normal).normalized()
			start_pos = result.position + dir * 4

		elif hit.is_in_group("bend_mirror"):
			reflections += 1

			# Triangle mirror bends the beam 90 degrees.
			# This version turns RIGHT -> DOWN, UP -> RIGHT, LEFT -> UP, DOWN -> LEFT
			dir = Vector2(dir.y, -dir.x).normalized()

			start_pos = result.position + dir * 0.5
		elif hit.is_in_group("target"):
			if reflections == required_reflections:
				print("Puzzle solved!")
			else:
				print("Wrong reflections: ", reflections)
			break

		else:
			break

	beam_line.points = points
