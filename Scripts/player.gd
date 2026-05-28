extends CharacterBody3D

@export var move_speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var look_sensitivity: float = 1.5
@export var look_smoothness: float = 10.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_yaw: float = 0.0
var target_pitch: float = 0.0
var current_pitch: float = 0.0

@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var image = Image.load_from_file("res://assets/cursor.png")

	image.resize(32, 32)

	var texture = ImageTexture.create_from_image(image)

	Input.set_custom_mouse_cursor(texture)

func _process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size
	var center := viewport_size / 2.0
	var mouse_from_center := mouse_pos - center

	var dead_zone := 120.0
	var max_turn_speed := 1.2

	if abs(mouse_from_center.x) > dead_zone:
		var turn_amount = (abs(mouse_from_center.x) - dead_zone) / center.x
		turn_amount = clamp(turn_amount, 0.0, 1.0)

		if mouse_from_center.x > 0:
			target_yaw -= max_turn_speed * turn_amount * delta
		else:
			target_yaw += max_turn_speed * turn_amount * delta

	if abs(mouse_from_center.y) > dead_zone:
		var pitch_amount = (abs(mouse_from_center.y) - dead_zone) / center.y
		pitch_amount = clamp(pitch_amount, 0.0, 1.0)

		if mouse_from_center.y > 0:
			target_pitch -= max_turn_speed * pitch_amount * delta
		else:
			target_pitch += max_turn_speed * pitch_amount * delta

	target_pitch = clamp(target_pitch, deg_to_rad(-60), deg_to_rad(60))

	rotation.y = lerp_angle(rotation.y, target_yaw, look_smoothness * delta)
	current_pitch = lerp(current_pitch, target_pitch, look_smoothness * delta)
	camera.rotation.x = current_pitch
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta



	var input_dir := Input.get_vector(
	"move_left",
	"move_right",
	"move_forward",
	"move_back"
	)

	print(input_dir)

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
