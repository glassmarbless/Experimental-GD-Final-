extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var notes_layer: Control = $Panel/NotesLayer
@onready var spell_display: Label = $Panel/SpellDisplay

 @onready var audio_players = {
	1: $Audio1,
	2: $Audio2,
	3: $Audio3,
	4: $Audio4,
	5: $Audio5,
	6: $Audio6,
	7: $Audio7,
	#8: $Audio8
}

var is_open: bool = false
var pressed_numbers: Array[int] = []

var spells := {
	 
	"1234": "Spell 1",
	"5678": "Spell 2",
	"1111": "Spell 3",
	"2468": "Spell 4"
	
}


var note_start_x: float = 1.014
var note_spacing: float = 80.0

var staff_top_y: float = 1.399
var staff_gap: float = 30.0

func get_note_y(number: int) -> float:
	var positions := {
		1: staff_top_y - staff_gap,        # above top line
		2: staff_top_y - staff_gap / 2,    # space above top line
		3: staff_top_y,                    # top line
		4: staff_top_y + staff_gap / 2,    # space
		5: staff_top_y + staff_gap,        # second line
		6: staff_top_y + staff_gap * 1.5,  # space
		7: staff_top_y + staff_gap * 2,    # third line
		8: staff_top_y + staff_gap * 2.5   # space
	}

	return positions[number] - 25

func _ready() -> void:
	layer = 10
	panel.visible = false
	panel.position = Vector2.ZERO
	panel.size = get_viewport().get_visible_rect().size
	spell_display.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		toggle_overlay()
		return

	if not is_open:
		return

	for i in range(1, 9):
		if event.is_action_pressed("number_%d" % i):
			add_number(i)

func toggle_overlay() -> void:
	is_open = !is_open
	panel.visible = is_open

func add_number(number: int) -> void:
	pressed_numbers.append(number)

	if pressed_numbers.size() > 4:
		pressed_numbers.pop_front()

	play_sound(number)
	draw_notes()
	check_spell()

func play_sound(number: int) -> void:
	if audio_players.has(number):
		audio_players[number].stop()
		audio_players[number].play()

func draw_notes() -> void:
	for child in notes_layer.get_children():
		child.queue_free()

	for index in range(pressed_numbers.size()):
		var number = pressed_numbers[index]

		var note := Label.new()
		note.text = str(number)
		note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		note.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		note.add_theme_font_size_override("font_size", 32)

		note.position = Vector2(
			note_start_x + index * note_spacing,
			get_note_y(number)
		)

		note.size = Vector2(50, 50)

		notes_layer.add_child(note)

func check_spell() -> void:
	if pressed_numbers.size() < 4:
		return

	var combo := ""
	for number in pressed_numbers:
		combo += str(number)

	if spells.has(combo):
		var spell_name = spells[combo]
		spell_display.text = spell_name
		print(spell_name)
