extends Node2D

@onready var pause_menu = $"UI/Pause Panel"
@onready var player = $Player/Player
@onready var camera = $Player/Player/Camera3D
@onready var alien = $Alien
@onready var HUD = $UI/HUD
@onready var dialogue_box = $"UI/Dialogue Box"
@onready var journal = $UI/Journal

var progress = 0
var tutorial = false
var rooms = []
var spells = []
var choices = []
var save_time = Time.get_datetime_string_from_system()
var game_end := false
var paused := false
var being_nice = false

var dialogue_state := false
var dialogue_location := Vector3(22,2.5,0)
var waiting_player_action := false
var dialogue_index := 0

var alien_dialogues := [
	{
		"words": ["who", "you"],
		"text": ""
	},
	{
		"words": ["me", "spaceship"],
		"text": ""
	},
	{
		"words": ["home", "where"],
		"text": ""
	},
	{
		"words": ["you", "me", "friend", "yes"],
		"text": ""
	},
	{
		"words": ["me", "open", "door", "spaceship"],
		"text": ""
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player.global_position)
	pause_menu.visible = false
	dialogue_box.visible = false
	journal.visible = false
	connect_doors()
	connect_alien()
	
	call_deferred("load_game_progress")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if player.spell_book_open:
			player.toggle_spell_book()
		journal.visible = false
		toggle_pause()
	
	if Input.is_action_just_pressed("journal"):
		if player.spell_book_open:
			player.toggle_spell_book()
		toggle_journal()
	
	if Input.is_action_just_pressed("open_menu"):
		journal.visible = false

func toggle_journal():
	journal.visible = !journal.visible
	if player.control_enabled:
		player.set_control_enabled(false)
	else:
		player.set_control_enabled(true)
	if dialogue_state and not journal.visible:
		player.toggle_spell_book()

func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	pause_menu.visible = paused

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_quit_button_pressed() -> void:
	toggle_pause()
	save_game_progress()
	get_tree().change_scene_to_file("res://Scenes/save_slots.tscn")

func save_game_progress():
	var data = SaveManager.load_game(SaveManager.current_slot)

	if data.is_empty():
		data = {}
	data["progress"] = progress
	data["current_scene"] = get_tree().current_scene.scene_file_path
	data["current_position"] = player.global_position
	data["player_rotation"] = player.rotation
	data["camera_yaw"] = player.yaw
	data["camera_pitch"] = player.pitch
	data["tutorial"] = tutorial
	data["unlocked_rooms"] = rooms
	data["unlocked_spells"] = spells
	data["choices_made"] = choices
	data["last_save_time"] = save_time
	SaveManager.save_game(SaveManager.current_slot, data)

	print("Game saved")
	print(player.yaw)
	print(player.pitch)

func load_game_progress():
	var data = SaveManager.load_game(SaveManager.current_slot)

	if data.is_empty():
		return
	
	SpellManager.load_from_save(data)

	if data.has("current_position"):
		player.global_position = data["current_position"]
	
	if data.has("player_rotation"):
		player.rotation = data["player_rotation"]

	if data.has("camera_yaw"):
		player.yaw = data["camera_yaw"]
		
	if data.has("camera_pitch"):
		player.pitch = data["camera_pitch"]
		
	rooms = data["unlocked_rooms"]
	spells = data["unlocked_spells"]

	print("Game loaded")
	restore_unlocked_doors()

func restore_unlocked_doors():
	for door in get_tree().get_nodes_in_group("spell_door"):
		if door.has_method("force_open_from_save"):
			if rooms.has(door.door_name):
				door.force_open_from_save()
	for door in get_tree().get_nodes_in_group("button_door"):
		if door.has_method("force_open_from_save"):
			if rooms.has(door.door_name):
				door.force_open_from_save()

func dialogue_mode():
	dialogue_state = true
	player.global_position = dialogue_location
	waiting_player_action = false
	HUD.visible = false
	dialogue_box.visible = true
	set_player_control(false)
	play_next_alien_dialogue()

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if dialogue_state and not waiting_player_action:
			show_music_player_stage()

	if event.is_action_pressed("test"):
		if dialogue_state and waiting_player_action:
			player_finished_music_stage()

func play_next_alien_dialogue():
	if dialogue_index >= alien_dialogues.size():
		trigger_game_end(1)
		return
	waiting_player_action = false
	var line = alien_dialogues[dialogue_index]
	dialogue_box.show_message(
		line["words"],
		line["text"]
	)
	dialogue_index += 1
		
	
func show_music_player_stage():
	if not player.spell_book_open:
		player.toggle_spell_book()
	waiting_player_action = true
			
func player_finished_music_stage():
	waiting_player_action = false
	if player.spell_book_open:
		player.toggle_spell_book()

	if dialogue_index == 4:
		if being_nice:
			play_next_alien_dialogue()
		else:
			trigger_game_end(2)
			
	play_next_alien_dialogue()
	
func end_dialogue_mode():
	dialogue_state = false
	waiting_player_action = false

	dialogue_box.visible = false
	if player.spell_book_open:
		player.toggle_spell_book()
	HUD.visible = true

	set_player_control(true)

	print("Dialogue mode finished")
	
func look_at_alien():
	var direction = alien.global_position - player.global_position
	direction.y = 0

	if direction.length() > 0:
		player.look_at(player.global_position + direction, Vector3.UP)	
	
func set_player_control(enabled: bool):
	if player.has_method("set_control_enabled"):
		player.set_control_enabled(enabled)
	
func _on_settings_button_pressed() -> void:
	toggle_pause()
	print(player.global_position)
	save_game_progress()
	SettingsManager.previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func connect_doors():
	for door in get_tree().get_nodes_in_group("spell_door"):
		if door.has_signal("door_opened"):
			door.door_opened.connect(_on_door_opened)
	for door in get_tree().get_nodes_in_group("button_door"):
		if door.has_signal("door_opened"):
			door.door_opened.connect(_on_door_opened)

func _on_door_opened(door_name: String):
	if not rooms.has(door_name):
		rooms.append(door_name)
	save_game_progress()
	print("Door saved as unlocked: ", door_name)

func connect_alien():
	player.alien_int.connect(dialogue_mode)

func connect_spell():
	player.spell_played.connect(_on_player_spell_played)

func _on_player_spell_played(spell_name: String):
	if not dialogue_state:
		return
	if not waiting_player_action:
		return
	if spell_name == "Yes":
		being_nice = true
		player_finished_music_stage()

	elif spell_name == "No":
		being_nice = false
		player_finished_music_stage()

func trigger_game_end(ending: int):
	end_dialogue_mode()
	game_end = true
	if ending == 1:
		good_end()
	if ending == 2:
		bad_end()

func bad_end():
	choices.append("bad_end")
	save_game_progress()
	get_tree().change_scene_to_file("res://Scenes/bad_end.tscn")

func good_end():
	choices.append("good_end")
	save_game_progress()
	get_tree().change_scene_to_file("res://Scenes/good_end.tscn")
