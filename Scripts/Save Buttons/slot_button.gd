extends Button

@export var slot_number := 1

func _ready():
	update_button_text()
	pressed.connect(_on_pressed)


func update_button_text():
	if SaveManager.save_exists(slot_number):
		var data = SaveManager.load_game(slot_number)
		text = "Load Slot %d\n%s" % [slot_number, data["last_save_time"]]
	else:
		text = "New Game Slot %d" % slot_number


func _on_pressed():
	if SaveManager.save_exists(slot_number):
		var data = SaveManager.load_game(slot_number)
		print("Loaded data: ", data)

		get_tree().change_scene_to_file(data["current_scene"])
	else:
		SaveManager.create_new_save(slot_number)
		get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
