extends Area2D
var is_night = false
var speed = 350.0
func _process(delta):
	position.x -= speed * delta
	if position.x < -80:
		queue_free()
	queue_redraw()
func _draw():
	var draw_color = Color.BLACK
	if is_night:
		draw_color = Color.WHITE
	draw_circle(Vector2.ZERO,12,draw_color)
	draw_line(
		Vector2(-12,0),
		Vector2(-22,-6),
		draw_color,
		2
	)
	draw_line(
		Vector2(12,0),
		Vector2(22,-6),
		draw_color,
		2
	)
