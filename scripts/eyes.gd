extends Node2D

var look_dir := Vector2.RIGHT

func _process(_delta):
	queue_redraw()
func _draw():
	var offset = look_dir * 2.0

	# White eyeballs
	draw_circle(
		Vector2(-9, -10),
		5.5,
		Color.WHITE
	)

	draw_circle(
		Vector2(9, -10),
		5.5,
		Color.WHITE
	)

	# Pupils
	draw_circle(
		Vector2(-9, -10) + offset,
		2.2,
		Color(0.1, 0.3, 1.0)
	)

	draw_circle(
		Vector2(9, -10) + offset,
		2.2,
		Color(0.1, 0.3, 1.0)
	)
