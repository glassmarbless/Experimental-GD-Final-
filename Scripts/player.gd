extends CharacterBody3D

@onready var interact_ray = $Camera3D/InteractRay
@onready var shader_test = get_tree().current_scene.get_node_or_null("ShaderTest")
@onready var alien: AnimatedSprite3D = get_tree().get_first_node_in_group("alien")
@export var move_speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var look_sensitivity: float = 0.15

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var control_enabled := true

@onready var camera: Camera3D = $Camera3D
@onready var spell_book_holder: Node3D = $Camera3D/SpellBookHolder

@onready var screen_viewport: SubViewport = $Camera3D/SpellBookHolder/ScreenViewport
@onready var notes_layer: Control = $Camera3D/SpellBookHolder/ScreenViewport/NumberOverlay2D/NotesLayer
@onready var spell_display: Label = $Camera3D/SpellBookHolder/ScreenViewport/NumberOverlay2D/SpellDisplay

@onready var audio_players = {
	1: $Camera3D/SpellBookHolder/Audio1,
	2: $Camera3D/SpellBookHolder/Audio2,
	3: $Camera3D/SpellBookHolder/Audio3,
	4: $Camera3D/SpellBookHolder/Audio4,
	5: $Camera3D/SpellBookHolder/Audio5,
	6: $Camera3D/SpellBookHolder/Audio6,
	7: $Camera3D/SpellBookHolder/Audio7,
	#8: $Camera3D/SpellBookHolder/Audio8
}

var has_spell_book := true

func unlock_spell_book() -> void:
	has_spell_book = true
	print("Player now has spell book")

var spell_book_open: bool = false
var pressed_numbers: Array[int] = []

var yaw: float = 0.0
var pitch: float = 0.0

var note_start_x: float = 130.0
var note_spacing: float = 120.0
var staff_top_y: float = 180.0
var staff_gap: float = 45.0

var spells := {
	"1234": "Me",
	"2222": "Friend",
	"1111": "Music",
	"2468": "Spaceship",
	"1818": "Home",
	"4321": "Door",
	"1357": "Open",
	"7777": "Yes",
	"8888": "No",
	"1212": "You"
}


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	spell_book_holder.visible = false
	spell_book_holder.position = Vector3(0, -1.15, -0.6)
	spell_book_holder.rotation_degrees = Vector3.ZERO
	spell_book_holder.scale = Vector3(1, 1, 1)

	spell_display.text = ""

func _process(delta: float) -> void:
	if get_tree().paused:
		return
		
	var viewport_size := get_viewport().get_visible_rect().size
	var mouse_pos := get_viewport().get_mouse_position()


	if Input.is_action_just_pressed("interact"):
		print("Pressed E")

		if interact_ray.is_colliding():
			var obj = interact_ray.get_collider()
			print("Ray hit: ", obj.name)

			if obj.is_in_group("puzzle_panel"):
				print("This is a puzzle panel")
				obj.interact()
		else:
			print("Hit object is NOT in puzzle_panel group")
	#else:
		 #print("Ray is not hitting anything")
func _input(event: InputEvent) -> void:

	if event.is_action_pressed("open_menu"):
		toggle_spell_book()
		return

	if not spell_book_open:
		
		if not control_enabled:
			return

		var viewport_size := get_viewport().get_visible_rect().size
		var mouse_pos := get_viewport().get_mouse_position()

		var center := viewport_size / 2.0
		var offset := mouse_pos - center

		var dead_zone := 360.0
		var turn_speed := 140.0

		if abs(offset.x) > dead_zone:

			var strength = (abs(offset.x) - dead_zone) / center.x
			strength = clamp(strength,0.0,1.0)

			if offset.x > 0:
				yaw -= turn_speed * strength * get_process_delta_time()
			else:
				yaw += turn_speed * strength * get_process_delta_time()

		if abs(offset.y) > dead_zone:

			var strength = (abs(offset.y) - dead_zone) / center.y
			strength = clamp(strength,0.0,1.0)

			if offset.y > 0:
				pitch -= turn_speed * strength * get_process_delta_time()
			else:
				pitch += turn_speed * strength * get_process_delta_time()

		pitch = clamp(pitch,-60,60)

		rotation_degrees.y = yaw
		camera.rotation_degrees.x = pitch

	if not spell_book_open:
		return

	for i in range(1,9):
		if event.is_action_pressed("number_%d" % i):
			add_number(i)
func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Vector2.ZERO

	if not spell_book_open:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func toggle_spell_book() -> void:
	# Spell book can be used from the start of the game.
	has_spell_book = true

	spell_book_open = !spell_book_open
	spell_book_holder.visible = spell_book_open

	if shader_test:
		shader_test.visible = !spell_book_open

	if spell_book_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pressed_numbers.clear()
		clear_notes()
		spell_display.text = ""
		print("Spell book opened")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		print("Spell book closed")

func add_number(number: int) -> void:
	pressed_numbers.append(number)

	if pressed_numbers.size() > 4:
		pressed_numbers.pop_front()

	play_sound(number)
	draw_notes()
	check_spell()

	print("Pressed numbers: ", pressed_numbers)


func play_sound(number: int) -> void:
	if audio_players.has(number):
		audio_players[number].stop()
		audio_players[number].play()


func draw_notes() -> void:
	clear_notes()

	var note_positions: Array[Vector2] = []

	# First, work out the centre position of every note.
	for index in range(pressed_numbers.size()):
		var number = pressed_numbers[index]
		var note_top_left := Vector2(
			note_start_x + index * note_spacing,
			get_note_y(number)
		)

		# Labels are 80x80, so +40 puts the line through the middle of the note.
		note_positions.append(note_top_left + Vector2(40, 40))

	# Draw the connecting line BEFORE the notes, so the numbers appear on top.
	if note_positions.size() > 1:
		var note_line := Line2D.new()
		note_line.name = "NoteLine"
		note_line.points = note_positions
		note_line.width = 3.0
		note_line.default_color = Color.WHITE
		note_line.z_index = 0
		notes_layer.add_child(note_line)

	# Now draw the note numbers.
	for index in range(pressed_numbers.size()):
		var number = pressed_numbers[index]

		var note := Label.new()
		note.text = str(number)
		note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		note.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		note.add_theme_font_size_override("font_size", 64)
		note.add_theme_color_override("font_color", Color.WHITE)
		note.size = Vector2(80, 80)
		note.z_index = 1

		note.position = Vector2(
			note_start_x + index * note_spacing,
			get_note_y(number)
		)

		notes_layer.add_child(note)


func clear_notes() -> void:
	for child in notes_layer.get_children():
		child.queue_free()


func get_note_y(number: int) -> float:
	var positions := {
		1: staff_top_y - staff_gap,
		2: staff_top_y - staff_gap / 2,
		3: staff_top_y,
		4: staff_top_y + staff_gap / 2,
		5: staff_top_y + staff_gap,
		6: staff_top_y + staff_gap * 1.5,
		7: staff_top_y + staff_gap * 2,
		8: staff_top_y + staff_gap * 2.5
	}

	return positions[number] - 40

func check_spell() -> void: 
	if pressed_numbers.size() < 4:
		return

	var combo := ""

	for number in pressed_numbers:
		combo += str(number)

	if spells.has(combo):
		var spell_name = spells[combo]
		spell_display.text = spell_name
		print(spell_name)

		if spell_name == "Door" or spell_name == "Open":
			get_tree().call_group("spell_door", "toggle_door")
			
		if spell_name == "No":
			if alien:
				alien.flash_alien_color(Color.RED,1.5)
			else:
				print("Alien not found")

	else:
		spell_display.text = ""
		print("No spell for combo: ", combo)


func set_control_enabled(enabled: bool):
	control_enabled = enabled
