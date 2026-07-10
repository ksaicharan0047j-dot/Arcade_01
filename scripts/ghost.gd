extends CharacterBody2D

enum GhostType {
	BLINKY,
	PINKY,
	INKY,
	CLYDE
}
@export var ghost_type := GhostType.BLINKY
@onready var sprite: AnimatedSprite2D = $Body

var look_dir := Vector2.RIGHT

func _ready():
	match ghost_type:
		GhostType.BLINKY:
			sprite.play("blinky")
		GhostType.PINKY:
			sprite.play("pinky")
		GhostType.INKY:
			sprite.play("inky")
		GhostType.CLYDE:
			sprite.play("clyde")

func _draw():
	draw_ghost_eyes()

func draw_ghost_eyes():
	var offset = look_dir * 1.6
	draw_circle(
		Vector2(-5,-7),
		4,
		Color.WHITE
	)
	draw_circle(
		Vector2(5,-7),
		4,
		Color.WHITE
	)
	draw_circle(
		Vector2(-5,-7) + offset,
		1.5,
		Color.BLUE
	)
	draw_circle(
		Vector2(5,-7) + offset,
		1.5,
		Color.BLUE
	)
