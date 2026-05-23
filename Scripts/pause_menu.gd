extends CanvasLayer

@onready var menu = $Panel

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func _on_resume_button_pressed():
	toggle_pause()

func _on_save_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/save_slots.tscn")
