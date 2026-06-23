extends CharacterBody2D
const SPEED = 500.0
func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
	position.x = clamp(position.x,60,1092)
func _draw():
	draw_rect(Rect2(-60,-10,120,20),Color.WHITE)
func _ready():
	position = Vector2(576,600)
	queue_redraw()
