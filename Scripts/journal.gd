extends Control

@onready var spell_holder = $"ScrollContainer/Spell Holder"

var spell_row_scene = preload("res://Scenes/spell_row.tscn")

func _ready():
	clear_spells()

func clear_spells():
	for child in spell_holder.get_children():
		child.queue_free()

func add_spell(spell_name: String):
	var spell_row = spell_row_scene.instantiate()
	spell_holder.add_child(spell_row)
	
	spell_row.setup(
	spell_name,
	SpellManager.get_spell_image(spell_name)
)
