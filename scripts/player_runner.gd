extends Node2D

const Ground_y = 520

const GRAVITY = 1700.0
const Jump_Force = -620.0

var velocity_y = 0.0
var is_crouching = false
var is_night = false

@onready var collision = $Area2D/CollisionShape2D
func _ready():
	position = Vector2(180,Ground_y)
func _process(delta):
	if Input.is_action_just_pressed("ui_up") and position.y >= Ground_y:
		velocity_y = Jump_Force
	velocity_y += GRAVITY * delta
	position.y += velocity_y * delta
	if position.y > Ground_y:
		position.y = Ground_y
		velocity_y = 0
	if Input.is_action_pressed("ui_down") and position.y >= Ground_y:
		crouch()
	else:
		stand()
	queue_redraw()

func crouch():
	is_crouching = true
	
	var shape = collision.shape as RectangleShape2D
	shape.size = Vector2(40,24)
	
	collision.position.y = 12
	
func stand():
	is_crouching = false
	
	var shape = collision.shape as RectangleShape2D
	shape.size = Vector2(20,48)
	
	collision.position.y = 0

func _draw():
	var draw_color = Color.BLACK
	if is_night:
		draw_color = Color.WHITE
	if is_crouching:
		draw_rect(
			Rect2(-20,-12,40,24),
			draw_color
		)
	else:
		draw_rect(
			Rect2(-10,-24,20,48),
			draw_color
		)


func _on_area_2d_area_entered(area):
	get_tree().call_group("game", "game_over")
