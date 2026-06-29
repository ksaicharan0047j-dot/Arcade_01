extends Node2D
@export var launcher_type := 0

func _ready():
	queue_redraw()

func _draw():
	draw_base()
	match launcher_type:
		0:
			draw_launcher_alpha()
		1:
			draw_launcher_bravo()
		2:
			draw_launcher_charlie()

func draw_base():
	#this concrete platform
	draw_rect(
		Rect2(-18,0,36,5),
		Color(0.72,0.72,0.74)
	)
	#front shadow
	draw_rect(
		Rect2(-18,5,36,2),
		Color(0.45,0.45,0.47)
	)
	#launcher slot
	draw_rect(
		Rect2(-7,-1,14,3),
		Color(0.16,0.16,0.17)
	)
	#slot high light
	draw_rect(
		Rect2(-7,-1,14,1),
		Color(0.28,0.28,0.3)
	)
	var bolt_color = Color(0.36,0.37,0.40)
	draw_circle(Vector2(-12,2),1.2,bolt_color)
	draw_circle(Vector2(12,2),1.2,bolt_color)
	draw_circle(Vector2(-12,5),1.2,bolt_color)
	draw_circle(Vector2(12,5),1.2,bolt_color)
	#botl highlights
	draw_circle(Vector2(-12,1.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(12,1.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(-12,4.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(12,4.5),0.45,Color(0.75,0.75,0.78))

func draw_launcher_alpha():
	#main body
	draw_rect(
		Rect2(-8,-36,16,36),
		Color(0.11,0.12,0.14)
	)
	#moon light
	draw_rect(
		Rect2(7,-36,1,36),
		Color(0.42,0.43,0.46)
	)
	#center armor
	draw_rect(
		Rect2(-5,-34,10,32),
		Color(0.16,0.17,0.20)
	)
	#Vertical panel seams
	draw_line(
		Vector2(0,-34),
		Vector2(0,-4),
		Color(0.07,0.07,0.08),
		1
	)
	draw_line(
		Vector2(-5,-22),
		Vector2(5,-22),
		Color(0.07,0.07,0.08),
		1
	)
	#left armor fin
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-14,-24),
			Vector2(-8,-30),
			Vector2(-8,-6),
			Vector2(-14,-2)
		]),
		Color(0.18,0.19,0.22)
	)
	#Right armor fin
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(14,-24),
			Vector2(8,-30),
			Vector2(8,-6),
			Vector2(14,-2)
		]),
		Color(0.18,0.19,0.22)
	)
	#left piston
	draw_line(
		Vector2(-10,-20),
		Vector2(-15,-13),
		Color(0.55,0.55,0.58),
		2
	)
	#Right piston
	draw_line(
		Vector2(10,-20),
		Vector2(15,-13),
		Color(0.55,0.55,0.58),
		2
	)
	#missile tube
	draw_rect(
		Rect2(-3,-50,6,16),
		Color(0.05,0.05,0.06)
	)
	#missile body
	draw_rect(
		Rect2(-2,-56,4,8),
		Color(0.25,0.25,0.28)
	)
	draw_rect(
		Rect2(-5,-50,10,3),
		Color(0.22,0.22,0.25)
	) 
	#Black missile tip
	var tip = PackedVector2Array()
	tip.append(Vector2(-2,-56))
	tip.append(Vector2(0,-64))
	tip.append(Vector2(2,-56))
	draw_colored_polygon(
		tip,
		Color(0.02,0.02,0.02)
	)
	
	#side vents
	for i in range(4):
		var y = -30 + i * 6
		
		draw_line(
			Vector2(-6,y),
			Vector2(-3,y),
			Color(0.05,0.05,0.05),
			1
		)
		draw_line(
			Vector2(3,y),
			Vector2(6,y),
			Color(0.05,0.05,0.05),
			1
		)
	#led housing
	draw_rect(
		Rect2(-5,-17,10,6),
		Color(0.08,0.08,0.09)
	)
	#Status Led's
	draw_circle(
		Vector2(-3,-14),
		1.5,
		Color(0.2,0.9,1.0)
	)
	draw_circle(
		Vector2(3,-14),
		1.5,
		Color(0.2,0.9,1.0)
	)
	#Hazard stripes
	draw_rect(
		Rect2(-5,-3,2,3),
		Color(1.0,0.76,0.2)
	)
	draw_rect(
		Rect2(-1,-3,2,3),
		Color(0.12,0.12,0.12)
	)
	draw_rect(
		Rect2(3,-3,2,3),
		Color(1.0,0.75,0.2)
	)
	draw_rect(
		Rect2(-5,-10,10,6),
		Color(0.09,0.09,0.10)
	)
	draw_rect(
		Rect2(-4,-9,8,1),
		Color(0.22,0.22,0.24)
	)
	draw_circle(
		Vector2(-3,-7),
		0.5,
		Color(0.55,0.55,0.58)
	)
	draw_circle(
		Vector2(3,-7),
		0.5,
		Color(0.55,0.55,0.58)
	)
	draw_line(
		Vector2(-2,-16),
		Vector2(2,-16),
		Color(0.62,0.62,0.65),
		1
	)
	draw_line(
		Vector2(-2,-14),
		Vector2(2,-14),
		Color(0.62,0.62,0.65),
		1
	)

func draw_launcher_bravo():
	draw_launcher_alpha()
	#extra armor
	draw_rect(
		Rect2(-15,-22,3,14),
		Color(0.26,0.27,0.30)
	)
	draw_rect(
		Rect2(12,-22,3,14),
		Color(0.26,0.27,0.30)
	)
	#leds
	draw_circle(
		Vector2(-3,-14),
		1.5,
		Color(1.0,0.72,0.2)
	)
	draw_circle(
		Vector2(3,-14),
		1.5,
		Color(1.0,0.72,0.2)
	)

func draw_launcher_charlie():
	draw_launcher_alpha()
	
	#top armor plate
	draw_rect(
		Rect2(-6,-41,12,3),
		Color(0.04,0.04,0.04)
	)
	
	#Extra vents
	for i in range(4):
		draw_rect(
			Rect2(-1,-30+i*6,2,2),
			Color(0.04,0.04,0.04)
		)
	# leds
	draw_circle(
		Vector2(-3,-14),
		1.5,
		Color(1.0,0.2,0.2)
	)
	draw_circle(
		Vector2(3,-14),
		1.5,
		Color(1.0,0.2,0.2)
	)
