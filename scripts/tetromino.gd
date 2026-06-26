extends Node2D
const I = [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0)
]
var cells = []
func _ready():
	cells = I.duplicate()
