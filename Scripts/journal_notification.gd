extends Control

@onready var texture_button = $TextureButton
@onready var journal = $"../Journal"

var tween: Tween

func show_notification():
	visible = true

	var screen_width = get_viewport_rect().size.x
	var hidden_x = screen_width
	var shown_x = screen_width - size.x - 5
	var tab_x = screen_width - 120

	position.x = hidden_x

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "position:x", shown_x, 0.5)
	tween.tween_interval(3.0)
	tween.tween_property(self, "position:x", tab_x, 0.5)
	tween.tween_interval(5.0)
	tween.tween_property(self, "position:x", hidden_x, 0.5)

	await tween.finished
	visible = false
