extends Node2D

func _ready():
	queue_redraw()

func _draw():
	draw_missile()

func draw_missile():
	#main body
	draw_rect(
		Rect2(-8,-72,16,72),
		Color(0.08,0.08,0.09)
	)
	#left body shadow
	draw_rect(
		Rect2(-8,-72,1,72),
		Color(0.04,0.04,0.04)
	)
	#top edge highlight
	draw_rect(
		Rect2(-7,-72,14,1),
		Color(0.24,0.24,0.26)
	)
	#Right highlight
	draw_rect(
		Rect2(4,-72,3,72),
		Color(0.28,0.28,0.30)
	)
	#nose 
	var nose = PackedVector2Array()
	
	nose.append(Vector2(-8,-72))
	nose.append(Vector2(0,-96))
	nose.append(Vector2(8,-72))
	
	draw_colored_polygon(
		nose,
		Color(0.02,0.02,0.02)
	)
	draw_rect(
		Rect2(-8,-72,16,2),
		Color(0.13,0.13,0.14)
	)
	draw_circle(
		Vector2(0,-66),
		1.4,
		Color(0.18,0.18,0.18)
	)
	
	#gudiance ring
	draw_rect(
		Rect2(-8,-56,16,4),
		Color(0.42,0.42,0.44)
	)
	#maintance panel
	draw_rect(
		Rect2(-6,-48,12,8),
		Color(0.12,0.12,0.13)
	)
	#panel highlight
	draw_rect(
		Rect2(-5,-47,10,1),
		Color(0.23,0.23,0.25)
	)
	var screw = Color(0.45,0.45,0.48)
	draw_circle(Vector2(-4,-44),1,screw)
	draw_circle(Vector2(4,-44),1,screw)
	
	draw_line(
		Vector2(0,-72),
		Vector2(0,0),
		Color(0.05,0.05,0.05),
		1
	)
	draw_line(
		Vector2(-8,-36),
		Vector2(8,-36),
		Color(0.16,0.16,0.17),
		1
	)
	draw_line(
		Vector2(-8,-22),
		Vector2(8,-22),
		Color(0.16,0.16,0.17),
		1
	)
	#engine housing
	draw_rect(
		Rect2(-8,0,16,8),
		Color(0.05,.05,0.06)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-8,0),
			Vector2(-12,4),
			Vector2(-8,8)
		]),
		Color(0.08,0.08,0.09)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(8,0),
			Vector2(12,4),
			Vector2(10,8),
			Vector2(8,8)
		]),
		Color(0.08,0.08,0.09)
	)
	draw_line(
		Vector2(-8,-28),
		Vector2(-5,-28),
		Color(0.03,0.03,0.03),
		1
	)
	draw_line(
		Vector2(5,-28),
		Vector2(8,-28),
		Color(0.03,0.03,0.03),
		1
	)
	draw_line(
		Vector2(-5,-12),
		Vector2(-2,-12),
		Color(0.18,0.18,0.18),
		1
	)
	draw_line(
		Vector2(2,-12),
		Vector2(5,-12),
		Color(0.18,0.18,0.18),
		1
	)
	#upper fins
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-8,-24),
			Vector2(-20,-8),
			Vector2(-8,-4)
		]),
		Color(0.12,0.12,0.13)
	)
	
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(8,-24),
			Vector2(20,-8),
			Vector2(8,-4)
		]),
		Color(0.12,0.12,0.13)
	)
	draw_line(
		Vector2(-10,-21),
		Vector2(-16,-10),
		Color(0.05,0.05,0.05),
		1
	)
	draw_line(
		Vector2(10,-21),
		Vector2(16,-10),
		Color(0.05,0.05,0.05),
		1
	)
