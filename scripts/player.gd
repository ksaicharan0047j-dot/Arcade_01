extends CharacterBody2D

const SPEED = 400

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		
	move_and_slide()
	
func _draw():
	draw_polygon([Vector2(0,-20), Vector2(-12, -12), Vector2(12, 12)],[Color.WHITE])
	
func _ready():
	queue_redraw()
