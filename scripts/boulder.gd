extends StaticBody2D
func _ready():
	queue_redraw()
func _draw():
	draw_circle(Vector2.ZERO,10,Color.DARK_GRAY)
