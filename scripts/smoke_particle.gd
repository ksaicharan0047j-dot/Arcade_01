extends Node2D

var life := 0.7
func _process(delta):
	life -= delta
	position.y += 8 * delta
	scale += Vector2.ONE * delta * 0.6
	if life <= 0:
		queue_free()
	queue_redraw()

func _draw():
	draw_circle(
		Vector2.ZERO,
		3,
		Color(0.75,0.75,0.75,life)
	)
	
