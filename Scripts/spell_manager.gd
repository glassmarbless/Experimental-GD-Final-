extends Node

#template: "hello": "res://Assets/UI/spells/hello.png",
signal spell_discovered(spell_name: String)
var discovered_spells: Array[String] = []
var spell_images := {
	"door": "res://Assets/Art/in game/journal combos/door.png",
	"friend": "res://Assets/Art/in game/journal combos/friend.png",
	"home": "res://Assets/Art/in game/journal combos/Home.png",
	"me": "res://Assets/Art/in game/journal combos/me.png",
	"no": "res://Assets/Art/in game/journal combos/NO.png",
	"yes": "res://Assets/Art/in game/journal combos/YES.png",
	"you": "res://Assets/Art/in game/journal combos/You.png"
}

func discover_spell(spell_name: String) -> void:
	if discovered_spells.has(spell_name):
		print("Spell already discovered: ", spell_name)
		return

	discovered_spells.append(spell_name)
	print("New spell discovered: ", spell_name)

	spell_discovered.emit(spell_name)

	# Save into current save slot
	if SaveManager.current_slot > 0:
		var data = SaveManager.load_game(SaveManager.current_slot)

		if data.is_empty():
			data = {}

		data["unlocked_spells"] = discovered_spells
		SaveManager.save_game(SaveManager.current_slot, data)


func get_spell_image(spell_name: String) -> Texture2D:
	if not spell_images.has(spell_name):
		print("Missing spell image: ", spell_name)
		return null

	return load(spell_images[spell_name])


func load_from_save(data: Dictionary) -> void:
	discovered_spells.clear()

	if data.has("unlocked_spells"):
		discovered_spells = data["unlocked_spells"].duplicate()

#template		
#"hello": [
		#"res://Assets/Audio/Notes/note_c.mp3",
		#"res://Assets/Audio/Notes/note_e.mp3",
		#"res://Assets/Audio/Notes/note_g.mp3"
	#],

var spell_notes := {
	"door": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	],
	"friend": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
	,
	"home": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
	,
	"me": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
	,
	"no": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
	,
	"yes": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
	,
	"you": [
		"res://Assets/Art/Audio/Notes/A synth note.wav",
		"res://Assets/Art/Audio/Notes/C synth note.wav",
		"res://Assets/Art/Audio/Notes/F synth note.wav",
		"res://Assets/Art/Audio/Notes/G-Note.wav"
	]
}

func get_spell_notes(spell_name: String) -> Array:
	if not spell_notes.has(spell_name):
		return []
	return spell_notes[spell_name]
