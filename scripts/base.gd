extends Node2D

func _ready():
	queue_redraw()
	print("base ready")

func _draw():
	draw_base()

func draw_base():
	#concrete platform 
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
		Rect2(-7,-1,14,1),
		Color(0.28,0.28,0.30)
	)
	#hinge
	draw_circle(
		Vector2(0,-2),
		5,
		Color(0.18,0.18,0.20)
	)
	draw_circle(
		Vector2(0,-2),
		3.6,
		Color(0.60,0.60,0.63),
	)
	#center pin
	draw_circle(
		Vector2(0,-2),
		1.6,
		Color(0.75,0.75,0.78)
	)
	draw_circle(
		Vector2(-1,-3),
		0.7,
		Color(0.95,0.95,0.97)
	)
	var bolt_color = Color(0.36,0.37,0.40)
	#bolts
	draw_circle(Vector2(-12,2),1.2,bolt_color)
	draw_circle(Vector2(12,2),1.2,bolt_color)
	draw_circle(Vector2(-12,5),1.2,bolt_color)
	draw_circle(Vector2(12,5),1.2,bolt_color)
	#Bolt highlights
	draw_circle(Vector2(-12,1.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(12,1.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(-12,4.5),0.45,Color(0.75,0.75,0.78))
	draw_circle(Vector2(12,4.5),0.45,Color(0.75,0.75,0.78))
