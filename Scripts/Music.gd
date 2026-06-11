extends Control

@onready var background: ColorRect = $Background
@onready var staff_lines: Control = $StaffLines
@onready var notes_layer: Control = $NotesLayer
@onready var spell_display: Label = $SpellDisplay

func _ready() -> void:
	size = Vector2(1024, 512)
	position = Vector2.ZERO

	background.position = Vector2.ZERO
	background.size = Vector2(1024, 512)
	background.color = Color("c0fbff")
	notes_layer.position = Vector2.ZERO
	notes_layer.size = Vector2(1024, 512)

	spell_display.position = Vector2(100, 400)
	spell_display.size = Vector2(824, 80)
	spell_display.text = "TEST"
	spell_display.add_theme_font_size_override("font_size", 48)

	make_staff_lines()


func make_staff_lines() -> void:
	for child in staff_lines.get_children():
		child.queue_free()

	for i in range(5):
		var line := ColorRect.new()
		background.color = Color("bdfaff")

		#line.color = Color.WHITE  
		line.position = Vector2(100, 170 + i * 45)
		line.size = Vector2(824, 4)
		staff_lines.add_child(line)
