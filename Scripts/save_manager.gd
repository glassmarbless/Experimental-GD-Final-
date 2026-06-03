extends Node

const SAVE_FOLDER := "user://saves/"
const SLOT_COUNT := 3

var current_slot := 1

func _ready():
	DirAccess.make_dir_recursive_absolute(SAVE_FOLDER)


func get_save_path(slot: int) -> String:
	return SAVE_FOLDER + "slot_%d.save" % slot


func create_new_save(slot: int):
	current_slot = slot

	var data = {
		"slot": slot,
		"progress": 0,
		"current_scene": "res://Scenes/Game.tscn",
		"current_position": Vector3(1,2,1),
		"tutorial": false,
		"unlocked_rooms": [],
		"unlocked_notes": [],
		"choices_made": [],
		"created_time": Time.get_datetime_string_from_system(),
		"last_save_time": get_formatted_time()
	}

	save_game(slot, data)

func get_formatted_time() -> String:
	var datetime := Time.get_datetime_dict_from_system()

	var day = datetime["day"]
	var month = datetime["month"]
	var year = datetime["year"]
	var hour = datetime["hour"]
	var minute = datetime["minute"]

	return "%02d/%02d/%04d %02d:%02d" % [
		day,
		month,
		year,
		hour,
		minute
	]

func save_game(slot: int, data: Dictionary):
	var file = FileAccess.open(get_save_path(slot), FileAccess.WRITE)
	file.store_var(data)
	file.close()


func load_game(slot: int) -> Dictionary:
	var path = get_save_path(slot)

	if not FileAccess.file_exists(path):
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()
	file.close()

	current_slot = slot
	return data


func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_save_path(slot))


func delete_save(slot: int):
	var path = get_save_path(slot)

	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
