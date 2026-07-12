extends CharacterBody2D

const SPEED := 120.0

var direction := Vector2.LEFT
var wanted_direction := Vector2.LEFT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite.play("move")

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_up"): 
		wanted_direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		wanted_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		wanted_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		wanted_direction = Vector2.RIGHT
	
	direction = wanted_direction
	velocity = direction * SPEED
	move_and_slide()
	update_sprite()

func update_sprite():
	if direction == Vector2.RIGHT:
		sprite.rotation_degrees = 0
		sprite.flip_v = false
	elif direction == Vector2.LEFT:
		sprite.rotation_degrees = 180
		sprite.flip_v = false
	elif direction == Vector2.UP:
		sprite.rotation_degrees = -90
		sprite.flip_v = false
	elif direction == Vector2.DOWN:
		sprite.rotation_degrees = 90
		sprite.flip_v = false
