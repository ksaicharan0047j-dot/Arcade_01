extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 150.0
var direction := Vector2.RIGHT

func _ready():
	sprite.play("move")
func _process(delta):
	position += direction * speed * delta
	if direction.x > 0:
		rotation = 0
	elif direction.x < 0:
		rotation = PI
	elif direction.y < 0:
		rotation = -PI / 2
	elif direction.y > 0:
		rotation = PI / 2
