extends Node2D

const GROUND_Y = 610

@onready var terrain = $Polygon2D
var points = PackedVector2Array()
func _ready():
	generate()
	
func generate():
	points.clear()
	var w = get_viewport_rect().size.x
	var h = get_viewport_rect().size.y
	#left edge
	points.append(Vector2(0, GROUND_Y))
	#left launcher
	add_hill(140,28,38,45)
	#middle launcher
	add_hill(576,36,42,50)
	#right launcher
	add_hill(1012,28,38,45)
	points.append(Vector2(w,GROUND_Y))
	points.append(Vector2(w,h))
	points.append(Vector2(0,h))
	terrain.polygon = points

func add_hill(center,height,top_width,slope_width):
	var left = center - top_width / 2
	var right = center + top_width / 2
	var start = left - slope_width
	var end = right + slope_width
	var steps = 24
	#left slope
	for i in range(steps + 1):
		var t = float(i) / steps
		var x = lerp(start, left, t)
		var s = t * t * (3.0 - 2.0 * t)
		var y = lerp(
			GROUND_Y,
			GROUND_Y - height,
			s
		)
		points.append(Vector2(x,y))
	#flat launcher platform
	points.append(Vector2(left, GROUND_Y - height))
	points.append(Vector2(right, GROUND_Y - height))
	#right slope
	for i in range(steps + 1):
		var t = float(i) / steps
		var x = lerp(right, end, t)
		var s = t * t * (3.0 - 2.0 * t)
		var y = lerp(
			GROUND_Y - height,
			GROUND_Y,
			s
		)
		points.append(Vector2(x,y))
