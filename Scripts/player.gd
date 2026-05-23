extends CharacterBody3D

@export var move_speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var look_sensitivity: float = 0.15
@export var look_smoothness: float = 3.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_yaw: float = 0.0
var target_pitch: float = 0.0
var current_pitch: float = 0.0

@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(delta: float) -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var mouse_pos := get_viewport().get_mouse_position()

	var center := viewport_size / 2.0
	var mouse_from_center := mouse_pos - center

	var max_distance := viewport_size.x / 2.0

	var yaw_offset := -mouse_from_center.x / max_distance
	var pitch_offset := -mouse_from_center.y / max_distance

	target_yaw = yaw_offset * deg_to_rad(45)
	target_pitch = pitch_offset * deg_to_rad(30)

	target_pitch = clamp(target_pitch, deg_to_rad(-30), deg_to_rad(30))

	rotation.y = lerp_angle(rotation.y, target_yaw, look_smoothness * delta)
	current_pitch = lerp(current_pitch, target_pitch, look_smoothness * delta)
	camera.rotation.x = current_pitch

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
