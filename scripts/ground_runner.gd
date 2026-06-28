extends Node2D
var is_night = false

const Ground_y = 544
func _draw():
	var draw_color = Color.BLACK
	if is_night:
		draw_color = Color.WHITE
	draw_line(
		Vector2(0, Ground_y),
		Vector2(1400, Ground_y),
		draw_color,
		4.0
	)
