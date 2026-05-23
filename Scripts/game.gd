extends Node2D

@onready var pause_menu = $"UI/Pause Panel"
@onready var player = $Player/Player
@onready var HUD = $UI/HUD

var progress = 0
var tutorial = false
var rooms = []
var notes = []
var choices = []
var save_time = Time.get_datetime_string_from_system()

var paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player.global_position)
	pause_menu.visible = false
	
	call_deferred("load_game_progress")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
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
