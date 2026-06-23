extends Node2D

func _draw():
	#outter border
	draw_rect(Rect2(0,0,1152,648),Color.WHITE,false,4)
	#Launcher lane
	draw_line(Vector2(1055,530),Vector2(1055,648),Color.WHITE,3)
func _ready():
	queue_redraw()   
