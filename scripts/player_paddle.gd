extends CharacterBody2D

const SPEED = 500.0
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= SPEED * delta
	if Input.is_action_pressed("ui_down"):
		position.y += SPEED * delta
	position.y = clamp(position.y,60,588)
func _draw():
	draw_rect(Rect2(-10,-60,20,120),Color.WHITE)
func _ready():
	queue_redraw()
