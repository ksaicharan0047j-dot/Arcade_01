extends StaticBody2D

var speed = 200.0
var direction = 1

func _process(delta):
	position.x += speed * direction * delta
	if position.x > 1100:
		direction = -1
		
	if position.x < 50:
		direction = 1
		
func _draw():
	draw_rect(Rect2(-100,-5,200,10),Color.WHITE)
	
func _ready():
	queue_redraw()
