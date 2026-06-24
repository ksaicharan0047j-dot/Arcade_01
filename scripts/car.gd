extends Area2D
var speed = 150
func _ready():
	queue_redraw()
func _draw():
	draw_rect(Rect2(-20,-10,40,20),Color.WHITE)
func _process(delta):
	position.x += speed * delta
	if speed > 0 and position.x > 1200:
		position.x = -50
	if speed < 0 and position.x < -50:
		position.x = 1200
	queue_redraw()
