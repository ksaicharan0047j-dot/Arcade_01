extends RigidBody2D
var launched = false
func _ready():
	position = Vector2(1080,570)
	queue_redraw()
	freeze = true
func _process(_delta):
	if !launched and Input.is_action_just_pressed("ui_accept"):
		launched = true
		freeze = false
		linear_velocity = Vector2(0,-1800)
func _draw():
	draw_circle(Vector2.ZERO,12,Color.WHITE)
