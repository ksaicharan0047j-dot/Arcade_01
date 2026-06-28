extends Node2D

var MOON_POS : Vector2
const MOON_RADIUS = 36

var time := 0.0

func _ready():
	var w = get_viewport_rect().size.x
	MOON_POS = Vector2(w * 0.84, 95)

func _process(delta):
	time += delta
	queue_redraw()
	
func _draw():
	
	var pulse = (sin(time * 0.4) + 1.0) * 0.5
	
	#Smooth glow
	for i in range(18):
		var r = MOON_RADIUS + 8 + i * 4
		var a = (0.045 - i * 0.002) * (0.85 + pulse * 0.3)
		if a > 0:
			draw_circle(
				MOON_POS,
				r,
				Color(1,1,1,a)
			)
	#Moon body
	draw_circle(
		MOON_POS,
		MOON_RADIUS,
		Color(0.96,0.96,0.96)
	)
	#soft rim
	draw_arc(
		MOON_POS,
		MOON_RADIUS,
		0,
		TAU,
		80,
		Color.WHITE,
		2
	)
	draw_craters()
	
func draw_craters():
	draw_circle(
		MOON_POS + Vector2(-12,-10),
		5,
		Color(0.82,0.82,0.82)
	)
	draw_circle(
		MOON_POS + Vector2(10,8),
		6,
		Color(0.83,0.83,0.83)
	)
	draw_circle(
		MOON_POS + Vector2(-4,15),
		3,
		Color(0.80,0.80,0.80)
	)
	draw_circle(
		MOON_POS + Vector2(8,-15),
		3,
		Color(0.84,0.84,0.84)
	)
	draw_circle(
		MOON_POS + Vector2(-18,4),
		2,
		Color(0.78,0.78,0.78)
	)
	draw_circle(
		MOON_POS + Vector2(18,-4),
		2,
		Color(0.80,0.80,0.80)
	)
