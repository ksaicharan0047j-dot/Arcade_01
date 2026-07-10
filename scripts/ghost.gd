extends CharacterBody2D

enum GhostType{
	BLINKY,
	PINKY,
	INKY,
	CLYDE
}

@export var ghost_type := GhostType.BLINKY
@export var ghost_color := Color.RED
