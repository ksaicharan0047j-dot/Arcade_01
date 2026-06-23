extends Area2D
var speed = 320.0
func _process(delta):
	position.x -= speed * delta
	if position.x < -100:
		queue_free()
func _draw():
	draw_rect(Rect2(-40,-150,80,300),Color.WHITE)
func _ready():
	queue_redraw()
