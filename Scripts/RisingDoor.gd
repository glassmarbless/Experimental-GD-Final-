extends Node3D

@export var rise_height := 4.0
@export var rise_speed := 2.0
@export var door_name := "door_1"

signal door_opened(door_name: String)

var is_open := false
var closed_pos: Vector3
var open_pos: Vector3

func _ready() -> void:
	closed_pos = global_position
	open_pos = closed_pos + Vector3.UP * rise_height

func toggle_door() -> void:
	is_open = !is_open
	door_opened.emit(door_name)

func _process(delta: float) -> void:
	var target := open_pos if is_open else closed_pos
	global_position = global_position.move_toward(target, rise_speed * delta)

func force_open_from_save():
	is_open = true
	global_position = open_pos
