extends Node2D

@onready var story_text = $Control/Story
@onready var cont_text = $Control/Continue

var full_text := "Drifting through space in your one-man ship, your radio picks up a strange frequency, a melody you can’t quite get out of your head.  Speeding between asteroid belts, you reach the source of the broadcast. A large metal hunk of a ship floats aimlessly, still emitting the same music as before you arrived.

Docking your ship beside it, you take a step inside... "
var is_typing := false
var finished := false
var typing_speed := 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cont_text.visible = false
	type_text()
	
func _process(delta: float) -> void: 
	if finished:
		show_continue()

func show_continue():
	await get_tree().create_timer(1).timeout
	cont_text.visible = true
	start_continue_flash()

func start_continue_flash():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(cont_text, "modulate:a", 0.5, 0.5)
	tween.tween_property(cont_text, "modulate:a", 1.0, 0.5)

func type_text():
	story_text.text = ""
	is_typing = true
	for letter in full_text:
		if finished:
			return
		story_text.text += letter
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false
	finished = true

func _input(event):
	if event.is_action_pressed("interact") and is_typing and !finished:
		story_text.text = full_text
		is_typing = false
		finished = true
