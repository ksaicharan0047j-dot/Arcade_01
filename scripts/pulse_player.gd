extends CharacterBody2D

const SPEED = 400.0

func _physics_process(delta):

	var dir = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		dir.x -= 1

	if Input.is_action_pressed("ui_right"):
		dir.x += 1

	if Input.is_action_pressed("ui_up"):
		dir.y -= 1

	if Input.is_action_pressed("ui_down"):
		dir.y += 1

	position += dir.normalized() * SPEED * delta

	position.x = clamp(position.x,20,1142)
	position.y = clamp(position.y,20,638)

func _draw():
	draw_rect(
		Rect2(-10,-10,20,20),
		Color.WHITE
	)

func _ready():
	position = Vector2(576,324)
	queue_redraw()
