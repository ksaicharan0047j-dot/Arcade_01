extends Node2D

const GROUND_Y = 610
func _ready():
	queue_redraw()
func _draw():
	draw_sky()
	draw_ground()
	
func draw_sky():
	draw_rect(
		Rect2(Vector2.ZERO,get_viewport_rect().size),
		Color.BLACK
	)

func draw_ground():
	var w = get_viewport_rect().size.x
	var h = get_viewport_rect().size.y
	
	var points = PackedVector2Array()
	
	points.append(Vector2(0, GROUND_Y))
	
	#LEFT HILL
	points.append(Vector2(w * 0.02, GROUND_Y))
	points.append(Vector2(w * 0.05, GROUND_Y - 20))
	points.append(Vector2(w * 0.08, GROUND_Y - 50))
	points.append(Vector2(w * 0.11, GROUND_Y - 85))
	points.append(Vector2(w * 0.14, GROUND_Y - 110))
	
	#Flat launcher platform
	points.append(Vector2(w * 0.17, GROUND_Y - 110))
	points.append(Vector2(w * 0.20, GROUND_Y - 110))
	
	points.append(Vector2(w * 0.23, GROUND_Y - 80))
	points.append(Vector2(w * 0.26, GROUND_Y - 40))
	points.append(Vector2(w * 0.30, GROUND_Y))
	
	#valley 1
	points.append(Vector2(w * 0.37, GROUND_Y - 12))
	points.append(Vector2(w * 0.45, GROUND_Y - 22))
	points.append(Vector2(w * 0.50, GROUND_Y - 10))
	
	#middle hill
	points.append(Vector2(w * 0.55, GROUND_Y - 45))
	points.append(Vector2(w * 0.58, GROUND_Y - 90))
	points.append(Vector2(w * 0.61, GROUND_Y - 130))
	
	#Flat launcher platform
	points.append(Vector2(w * 0.64, GROUND_Y - 130))
	points.append(Vector2(w * 0.67, GROUND_Y - 130))
	
	points.append(Vector2(w * 0.70, GROUND_Y - 90))
	points.append(Vector2(w * 0.73, GROUND_Y - 45))
	points.append(Vector2(w * 0.77, GROUND_Y))
	
	#valley 2
	points.append(Vector2(w * 0.82, GROUND_Y - 15))
	points.append(Vector2(w * 0.87, GROUND_Y - 25))
	points.append(Vector2(w * 0.91, GROUND_Y - 15))
	
	#Right hill
	points.append(Vector2(w * 0.95, GROUND_Y - 45))
	points.append(Vector2(w * 0.98, GROUND_Y - 95))
	points.append(Vector2(2 * 1.01, GROUND_Y - 110))
	
	#Flat launcher platform
	points.append(Vector2(w * 1.04, GROUND_Y - 110))
	points.append(Vector2(w, GROUND_Y))
	
	#FILL
	points.append(Vector2(w, h))
	points.append(Vector2(0, h))
	
	draw_colored_polygon(points, Color.WHITE)
