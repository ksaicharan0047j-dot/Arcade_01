extends Node2D

var led_on := false
var blink_timer := 0.0
var blink_interval := 0.35
var target: Node2D = null
var speed := 0.0
const MAX_SPEED := 700.0
const ACCELERATION := 2200.0
var flame_fliker := 0.0
var smoke_timer := 0.0
const SMOKE = preload("res://scenes/smoke_particle.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")

func _process(delta):
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0
		led_on = !led_on
		queue_redraw()
	if target == null:
		return
	speed = move_toward(
		speed,
		MAX_SPEED,
		ACCELERATION * delta
	)
	flame_fliker += delta * 20
	smoke_timer += delta
	queue_redraw()
	var dir = (target.global_position - global_position).normalized()
	global_position += dir * speed * delta
	rotation = dir.angle() + PI / 2
	if global_position.distance_to(target.global_position) < 8:
		var explosion = EXPLOSION.instantiate()
		explosion.Start_radius = 8.0
		explosion.Min_radius = 6.0
		explosion.Max_radius = 28.0
		explosion.End_radius = 10.0
		get_parent().add_child(explosion)
		explosion.global_position = target.global_position
		target.queue_free()
		queue_free()
	if smoke_timer >= 0.03:
		smoke_timer = 0
		var smoke = SMOKE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position + Vector2(0,6)

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
	#Upper armor panel
	draw_rect(
		Rect2(-6,-60,12,12),
		Color(0.12,0.12,0.13)
	)
	#Lower armor panel
	draw_rect(
		Rect2(-6,-36,12,14),
		Color(0.12,0.12,0.13)
	)
	draw_line(
		Vector2(-6,-48),
		Vector2(6,-48),
		Color(0.05,0.05,0.05),
		1
	)
	draw_line(
		Vector2(-6,-22),
		Vector2(6,-22),
		Color(0.05,0.05,0.05),
		1
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
	#LED
	draw_circle(
		Vector2(0,-66),
		2.2,
		Color(0.05,0.05,0.05)
	)
	#Red LED
	var led_color = Color(0.25,0.02,0.02)
	if led_on:
		led_color = Color(1.0,0.08,0.08)
	draw_circle(
		Vector2(1,-66),
		1.2,
		led_color
	)
	#glass reflection 
	draw_circle(
		Vector2(-0.4,-66.4),
		0.4,
		Color(1.0,0.85,0.85)
	)
	#Sensor glass highlight
	draw_circle(
		Vector2(-0.5,-66.5),
		0.5,
		Color(0.55,0.55,0.58)
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
	draw_rect(
		Rect2(-6,2,12,1),
		Color(0.20,0.20,0.22)
	)
	#exhaust opening
	draw_rect(
		Rect2(-2,6,4,2),
		Color(0.01,0.01,0.01)
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
		Vector2(9,-22),
		Vector2(-16,-10),
		Color(0.05,0.05,0.05),
		1
	)
	draw_line(
		Vector2(9,-22),
		Vector2(16,-10),
		Color(0.05,0.05,0.05),
		1
	)
	draw_line(
		Vector2(10,-21),
		Vector2(16,-10),
		Color(0.05,0.05,0.05),
		1
	)
	var bolt = Color(0.45,0.45,0.48)
	draw_circle(Vector2(-4,-54),0.8,bolt)
	draw_circle(Vector2(4,-54),0.8,bolt)
	draw_circle(Vector2(-4,-30),0.8,bolt)
	draw_circle(Vector2(4,-30),0.8,bolt)
	var flame_length = 8.0 + sin(flame_fliker) * 2.0
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-2,8),
			Vector2(0,8 + flame_length),
			Vector2(2,8),
		]),
		Color(1.0,0.55,0.08)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-1,8),
			Vector2(0,5 + flame_length),
			Vector2(1,8)
		]),
		Color(1.0,0.95,0.55)
	)
