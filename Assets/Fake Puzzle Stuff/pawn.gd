extends TextureRect

@export var move_time := 0.6

var path := [
	Vector2(246, 220), # Start

	Vector2(246, 345),
	Vector2(373, 345),
	Vector2(373, 475),
	Vector2(373, 605),
	Vector2(373, 735),
	Vector2(503, 735),
	Vector2(503, 607),
	Vector2(628, 607),
	Vector2(632, 732),
	
	Vector2(758, 732)# End
]

func _ready():
	position = path[0]

	await get_tree().create_timer(5).timeout

	play_path()

func play_path():
	for i in range(1, path.size()):
		var tween = create_tween()
		tween.tween_property(
			self,
			"position",
			path[i],
			move_time
		)
		await tween.finished
