extends RefCounted
var shape_name = ""
const SHAPES = {
"I" : [
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(2,0)
	],
"O" : [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(0,1),
	Vector2i(1,1)
	],
"T" : [
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(0,1)
	],
"S" : [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(-1,1),
	Vector2i(0,1)
	],
"Z" : [
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(0,1),
	Vector2i(1,1)
	],
"J" : [
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(-1,1)
	],
"L" : [
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(1,1)
	]
}
var cells = []
func _init(shape := "I"):
	shape_name = shape
	cells = SHAPES[shape].duplicate(true)
func rotate():
	if shape_name == "O":
		return
	var rotated = []
	for cell in cells:
		rotated.append(Vector2i(-cell.y,cell.x))
	cells = rotated
