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
