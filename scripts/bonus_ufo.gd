extends Area2D
signal destroyed
var speed = 300
func _ready():
	queue_redraw()
func _process(delta):
	position.x += speed * delta
	if position.x < -80 or position.x > 1232:
		queue_free()
	queue_redraw()
func _draw():
	draw_ellipse(Vector2(0,0),25,10,Color.MAGENTA)
	draw_ellipse(Vector2(0,-8),10,6,Color.CYAN)
func die():
	destroyed.emit()
	queue_free()
