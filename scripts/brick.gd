extends Area2D
func _draw():
	draw_rect(Rect2(-40,-15,80,30),Color.WHITE)
func _ready():
	queue_redraw()
func hit():
	queue_free()
