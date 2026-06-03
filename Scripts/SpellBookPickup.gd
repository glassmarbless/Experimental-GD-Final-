extends Area3D

@export var prompt_label: Label

var player_near := false
var player: Node = null
var picked_up := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if prompt_label:
		prompt_label.visible = false
	else:
		print("PROMPT LABEL NOT SET")
func _process(_delta: float) -> void:
	if player_near and not picked_up:
		if prompt_label:
			prompt_label.visible = true
			prompt_label.text = "Press E to pick up spell book"

		if Input.is_action_just_pressed("interact"):
			pick_up_book()

func _on_body_entered(body: Node) -> void:
	print("Entered: ", body.name, " group player? ", body.is_in_group("player"))

	if body.is_in_group("player"):
		player = body
		player_near = true


func _on_body_exited(body: Node) -> void:
	if body == player:
		player_near = false
		player = null

		if prompt_label:
			prompt_label.visible = false

func pick_up_book() -> void:
	picked_up = true

	if prompt_label:
		prompt_label.visible = false

	if player:
		player.has_spell_book = true

	get_parent().visible = false
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
