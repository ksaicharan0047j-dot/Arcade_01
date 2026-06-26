extends Node2D
const SIZE = 28 
var color = Color.WEB_GREEN
func _ready():
	queue_redraw()
func _draw():
	draw_rect(Rect2(0,0,SIZE,SIZE),color)
	#border
	draw_rect(Rect2(0,0,SIZE,SIZE),Color.WHITE,false,2)
	draw_line(Vector2(2,2),Vector2(SIZE - 2,2),Color(1,1,1,0.5),2)
	draw_line(Vector2(2,2),Vector2(2,SIZE - 2),Color(1,1,1,0.5),2)
