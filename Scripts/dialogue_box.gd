extends Control

@onready var grid = $Message/Notes
@onready var text_lable = $Message/Text
@onready var audio_player = $AudioStreamPlayer

var images = SpellManager.spell_images

var typing_speed := 0.03
var full_text := ""
var is_typing := false

func show_message(words: Array, text: String):
	clear_images()
	for word in words:
		add_word_image(word)
		var notes = SpellManager.get_spell_notes(word)
		for note_path in notes:
			var stream = load(note_path)
			if stream == null:
				continue
			audio_player.stream = stream
			audio_player.play()
			await get_tree().create_timer(0.8).timeout
		audio_player.stop()
		await get_tree().create_timer(1.2).timeout
	
		
func add_word_image(word: String):
	if !images.has(word):
		return
	var texture_rect := TextureRect.new()
	texture_rect.texture = load(images[word])
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	texture_rect.custom_minimum_size = Vector2(80, 80)
	grid.add_child(texture_rect)

func type_text(text: String):
	full_text = text
	text_lable.text = ""
	is_typing = true
	for letter in text:
		text_lable.text += letter
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false

func _input(event):
	if event.is_action_pressed("interact") and is_typing:
		text_lable.text = full_text
		is_typing = false

func clear_images():
	for child in grid.get_children():
		child.queue_free()

func hide_dialogue():
	visible = false
	
	
