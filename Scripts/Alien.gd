extends AnimatedSprite3D

@export var player_path: NodePath

@onready var player: Node3D = get_node_or_null(player_path)

func _ready() -> void:
	play("default")
	modulate = Color.WHITE

func _process(delta: float) -> void:
	if player:
		var target := player.global_position
		target.y = global_position.y
		look_at(target, Vector3.UP)

func flash_alien_color(
	color: Color,
	duration: float = 1.0
) -> void:

	modulate = color

	var tween = create_tween()

	tween.tween_property(
		self,
		"modulate",
		Color.WHITE,
		duration
	)
