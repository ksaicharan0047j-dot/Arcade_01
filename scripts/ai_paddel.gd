extends CharacterBody2D

const SPEED = 350.0
var ball
func _ready():
	queue_redraw()
	ball = get_parent().get_node("Ball")
func _physics_process(delta):
	if ball.position.y < position.y - 20:
		position.y -= SPEED * delta
	elif ball.position.y > position.y + 20:
		position.y += SPEED * delta
	position.y = clamp(position.y,60,588)
func _draw():
	draw_rect(Rect2(-10,-60,20,120),Color.WHITE)
