extends Node2D

@onready var pause_menu = $"UI/Pause Panel"
@onready var player = $Player/Player
@onready var alien = $Alien
@onready var HUD = $UI/HUD
@onready var dialogue_box = $"UI/Dialogue Box"

var progress = 0
var tutorial = false
var rooms = []
var notes = []
var choices = []
var save_time = Time.get_datetime_string_from_system()

var paused := false

var dialogue_state := false
var dialogue_location := Vector3(0,0,0)
var waiting_player_action := false
var dialogue_index := 0

var alien_dialogues := [
	{
		"words": [],
		"text": ""
	},
	{
		"words": [],
		"text": ""
	},
	{
		"words": [],
		"text": ""
	},
	{
		"words": [],
		"text": ""
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player.global_position)
	pause_menu.visible = false
	dialogue_box.visible = false
	
	call_deferred("load_game_progress")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if player.spell_book_open:
			player.toggle_spell_book()
		toggle_pause()

func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	pause_menu.visible = paused

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_quit_button_pressed() -> void:
	toggle_pause()
	print(player.global_position)
	save_game_progress()
	get_tree().change_scene_to_file("res://Scenes/save_slots.tscn")

func save_game_progress():
	var data = SaveManager.load_game(SaveManager.current_slot)

	if data.is_empty():
		data = {}
	data["progress"] = progress
	data["current_scene"] = get_tree().current_scene.scene_file_path
	data["current_position"] = player.global_position
	data["tutorial"] = tutorial
	data["unlocked_rooms"] = rooms
	data["unlocked_notes"] = notes
	data["choices_made"] = choices
	data["last_save_time"] = save_time
	SaveManager.save_game(SaveManager.current_slot, data)

	print("Game saved")


func load_game_progress():
	var data = SaveManager.load_game(SaveManager.current_slot)

	if data.is_empty():
		return

	if data.has("current_position"):
		player.global_position = data["current_position"]

	print("Game loaded")


func dialogue_mode():
	dialogue_state = true
	player.global_position = dialogue_location
	waiting_player_action = false
	HUD.visible = false
	dialogue_box.visible = true
	set_player_control(false)
	
func play_next_alien_dialogue():
	if dialogue_index >= alien_dialogues.size():
		end_dialogue_mode()
		return

	waiting_player_action = false
	if player.spell_book_open:
		player.toggle_spell_book()

	var line = alien_dialogues[dialogue_index]

	dialogue_box.show_message(
		line["words"],
		line["text"]
	)

	dialogue_index += 1

	if Input.is_action_pressed("interact"):
		show_music_player_stage()
	
func show_music_player_stage():
	if !player.spell_book_open:
		player.toggle_spell_book()
	waiting_player_action = true

	print("Music player stage placeholder")
	
func player_finished_music_stage():
	if not waiting_player_action:
		return

	waiting_player_action = false
	if player.spell_book_open:
		player.toggle_spell_book()
	dialogue_box.visible = true

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
	
	
	
	
	
