extends Node3D

@export var rise_height: float = 4.0
@export var rise_speed: float = 2.0

var is_open := false
var closed_position: Vector3
var open_position: Vector3

func _ready() -> void:
	closed_position = position
	open_position = closed_position + Vector3(0, rise_height, 0)

func toggle_door() -> void:
	is_open = !is_open

func _process(delta: float) -> void:
	var target_position = open_position if is_open else closed_position
	position = position.move_toward(target_position, rise_speed * delta)
