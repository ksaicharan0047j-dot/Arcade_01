extends Area2D
const SPEED = 700
func _read0y():
	queue_redraw()
func _process(delta):
	position.y -= SPEED * delta
	if position.y < -20:
		queue_free()
	queue_redraw()
func _draw():
	draw_rect(Rect2(-2,-10,4,20),Color.YELLOW)
