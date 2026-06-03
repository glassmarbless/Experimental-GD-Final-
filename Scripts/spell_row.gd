extends HBoxContainer

@onready var image_rect: TextureRect = $Image
@onready var input_box: LineEdit = $"Input Area/Input"
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var spell_name := ""
var is_playing_notes := false

func setup(new_spell_name: String, spell_image: Texture2D):
	spell_name = new_spell_name
	image_rect.texture = spell_image

func _on_play_sound_pressed() -> void:
	if is_playing_notes:
		return
	play_spell_notes()

func play_spell_notes():
	is_playing_notes = true

	var notes = SpellManager.get_spell_notes(spell_name)

	for note_path in notes:
		var stream = load(note_path)

		if stream == null:
			continue

		audio_player.stream = stream
		audio_player.play()

		await get_tree().create_timer(0.8).timeout
	audio_player.stop()

	is_playing_notes = false
