extends Node2D

var mouth_angle := 35.0
var opening := true

func _process(delta):
	if opening:
		mouth_angle += 180 * delta
		if mouth_angle >= 45:
			opening = false
	else:
		mouth_angle -= 180 * delta
		if mouth_angle <= 10:
			opening = true
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO,22,Color.YELLOW)
	draw_polygon(
		PackedVector2Array([
			Vector2.ZERO,
			Vector2.from_angle(deg_to_rad(-mouth_angle)) * 26,
			Vector2.from_angle(deg_to_rad(mouth_angle)) * 26
		]),
		[Color.BLACK]
	)
