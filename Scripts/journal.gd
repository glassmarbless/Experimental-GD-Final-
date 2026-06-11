extends Control

@onready var spell_holder = $"ScrollContainer/Spell Holder"

var spell_row_scene = preload("res://Scenes/spell_row.tscn")

func _ready():
	clear_spells()

	if not SpellManager.spell_discovered.is_connected(add_spell):
		SpellManager.spell_discovered.connect(add_spell)

	for spell_name in SpellManager.discovered_spells:
		add_spell(spell_name)

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
