extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var number_display: Label = $Panel/NumberDisplay

@onready var audio_players = {
	1: $Audio1,
	2: $Audio2,
	3: $Audio3,
	4: $Audio4,
	5: $Audio5,
	6: $Audio6,
	7: $Audio7,
	8: $Audio8
}

var is_open: bool = false
var pressed_numbers: Array[int] = []


func _ready() -> void:
	layer = 10
	panel.visible = false
	panel.position = Vector2.ZERO
	panel.size = get_viewport().get_visible_rect().size
	number_display.text = "Pressed:"


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

	number_display.text = "Pressed: " + str(pressed_numbers)

	play_sound(number)


func play_sound(number: int) -> void:
	if audio_players.has(number):
		audio_players[number].play()
