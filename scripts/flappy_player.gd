extends CharacterBody2D
const GRAVITY = 1400.0
const JUMP_FORCE = -420.0
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_FORCE
	move_and_slide()
	if position.y < 0:
		position.y = 0
func _draw():
	draw_rect(Rect2(-10,-10,20,20),Color.WHITE)
func _ready():
	position = Vector2(300,324)
	queue_redraw()
