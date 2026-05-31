extends AnimatedSprite3D

@export var player_path: NodePath

@onready var player: Node3D = get_node(player_path)

func _ready() -> void:
	play("idle")

func _process(delta: float) -> void:
	if player:
		look_at(player.global_position, Vector3.UP)
		rotation_degrees.x = 0
