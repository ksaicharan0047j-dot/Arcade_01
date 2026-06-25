extends Area2D
var speed = 150
func _ready():
	queue_redraw()
func _draw():
	draw_rect(Rect2(-20,-10,40,20),Color.WHITE)
func _process(delta):
	position.x += speed * delta
	if speed > 0 and position.x > 1220:
		position.x = -80
	if speed < 0 and position.x < -80:
		position.x = 1220
	queue_redraw()
func _on_body_entered(body):
	if body.name == "Frog":
		body.hit()
