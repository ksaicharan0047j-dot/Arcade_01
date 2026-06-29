extends Node2D

func _ready():
	queue_redraw()

func _draw():
	var c = Color(0.95,0.95,0.97)
	#center dot
	draw_circle(
		Vector2.ZERO,
		2,
		c
	)
	#u left
	draw_line(
		Vector2(-7,-7),
		Vector2(-3,-3),
		c,
		1
	)
	#u right
	draw_line(
		Vector2(7,-7),
		Vector2(3,-3),
		c,
		1
	)
	#l left
	draw_line(
		Vector2(-7,7),
		Vector2(-3,3),
		c,
		1
	)
	#l right
	draw_line(
		Vector2(7,7),
		Vector2(3,3),
		c,
		1
	)
