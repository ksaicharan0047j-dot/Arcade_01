extends Area2D
var is_night =  false
var speed = 400.0

func _process(delta):
	position.x -= speed * delta
	queue_redraw()
	if position.x < -100:
		queue_free()

func _draw():
	var draw_color = Color.BLACK
	if is_night:
		draw_color = Color.WHITE
	draw_polygon(
		[
			Vector2(-15,15),
			Vector2(0,-15),
			Vector2(15,15)
		],
		[draw_color]
	)
