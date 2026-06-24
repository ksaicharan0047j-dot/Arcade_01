extends Node2D
var lane_type = "grass"
var lane_direction = 0
func _draw():
	if lane_type == "grass":
		draw_rect(Rect2(0,0,1152,40),Color.DARK_GREEN)
	elif lane_type == "left":
		draw_rect(Rect2(0,0,1152,40),Color.DIM_GRAY)
	elif lane_type == "right":
		draw_rect(Rect2(0,0,1152,40),Color.DIM_GRAY)
	draw_line(Vector2(0,0),Vector2(1152,0),Color.WHITE,2)
func _ready():
	queue_redraw()
