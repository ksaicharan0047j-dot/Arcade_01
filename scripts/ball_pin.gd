extends RigidBody2D
func _draw():
	draw_circle(Vector2.ZERO,12,Color.WHITE)
func _ready():
	position = Vector2(1050,550)
	queue_redraw()
	sleeping = true
func _input(event):
	if sleeping and event.is_action_pressed("ui_accept"):
		sleeping = false
		linear_velocity = Vector2(-800,-1800)
