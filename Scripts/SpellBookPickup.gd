extends Area3D

@export var prompt_label: Label
@export var player_path: NodePath
@export var pickup_distance: float = 3.0

var picked_up := false
var player

func _ready():

	player = get_node(player_path)

	if prompt_label:
		prompt_label.visible = false


func _process(_delta):

	if picked_up:
		return

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= pickup_distance:

		if prompt_label:

			prompt_label.visible = true
			prompt_label.text = "Press E to pick up spell book"

		if Input.is_key_pressed(KEY_E):

			pick_up_book()

	else:

		if prompt_label:

			prompt_label.visible = false


func pick_up_book():

	picked_up = true

	if prompt_label:

		prompt_label.visible = false

	var real_player = get_tree().get_first_node_in_group("player")

	if real_player:
		real_player.set("has_spell_book", true)
		print("Spell book unlocked")
	else:
		print("Could not find player group")

	# Hide the whole spellbook object
	get_parent().visible = false
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
