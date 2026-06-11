extends Button

@export var slot_number := 1

func _ready():
	update_button_text()
	pressed.connect(_on_pressed)

func update_button_text():
	if SaveManager.save_exists(slot_number):
		var data = SaveManager.load_game(slot_number)
		var save_time = data.get("last_save_time", "Unknown save time")
		text = "Load Slot %d\n%s" % [slot_number, save_time]
	else:
		text = "New Game Slot %d" % slot_number

func _on_pressed():
	if SaveManager.save_exists(slot_number):
		var data = SaveManager.load_game(slot_number)
		print("Loaded data: ", data)

		var choices = data.get("choices_made", [])

		if choices.has("good_end"):
			get_tree().change_scene_to_file("res://Scenes/good_end.tscn")
			return
		
		if choices.has("bad_end"):
			get_tree().change_scene_to_file("res://Scenes/bad_end.tscn")
			return

		var scene_path = data.get("current_scene", "res://Scenes/Game2.tscn")
		get_tree().change_scene_to_file(scene_path)
	else:
		SaveManager.create_new_save(slot_number)
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func _on_delete_button_pressed() -> void:
	SaveManager.delete_save(slot_number)
	update_button_text()
