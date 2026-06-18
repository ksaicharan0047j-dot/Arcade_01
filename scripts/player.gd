extends CharacterBody2D

const SPEED := 500.0
const SCREEN_WIDTH := 1152.0

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		
	move_and_slide()
	global_position.x = clamp(global_position.x, 20, SCREEN_WIDTH - 20)
	
func _draw():
	draw_polygon([Vector2(0,-20), Vector2(-12, -12), Vector2(12, 12)],[Color.WHITE])
	
func _ready():
	queue_redraw()
