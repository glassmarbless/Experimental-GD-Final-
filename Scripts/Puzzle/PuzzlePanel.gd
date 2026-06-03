extends Area3D

@export var puzzle_scene: PackedScene
@export var canvas_layer: CanvasLayer

var puzzle_open := false

func interact():
	if puzzle_open:
		return

	if puzzle_scene == null:
		print("ERROR: puzzle_scene is not set")
		return

	var puzzle = puzzle_scene.instantiate()

	if canvas_layer != null:
		canvas_layer.add_child(puzzle)
	else:
		get_tree().current_scene.add_child(puzzle)

	puzzle_open = true
	print("Puzzle opened")
