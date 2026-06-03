extends StaticBody2D

func _ready():
	add_to_group("target")

func check_success(reflections: int, required_reflections: int):
	if reflections == required_reflections:
		print("Puzzle solved!")
	else:
		print("Light reached target, but wrong reflection count.")
		print("Reflections:", reflections, " Required:", required_reflections)
