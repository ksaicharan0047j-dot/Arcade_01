extends Area2D

const MAX_SPEED := 180.0
var target: Node2D = null
var flame_flicker := 0.0
var smoke_timer := 0.0

const SMOKE  = preload("res://scenes/smoke_particle.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")
func _ready():
	add_to_group("enemy_missiles")
	queue_redraw()

func _process(delta):
	if !is_instance_valid(target):
		queue_free()
		return
	flame_flicker += delta * 18.0
	smoke_timer += delta
	var dir = (target.global_position - global_position).normalized()
	global_position += dir * MAX_SPEED * delta
	rotation = dir.angle() + PI / 2.0
	if smoke_timer >= 0.04:
		smoke_timer = 0.0
		var smoke = SMOKE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position + Vector2(0,6)
	if global_position.distance_to(target.global_position) < 8:
		var explosion = EXPLOSION.instantiate()
		explosion.use_shockwave = false
		explosion.Start_radius = 10.0
		explosion.Min_radius = 8.0
		explosion.Max_radius = 24.0
		explosion.End_radius = 8.0
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		target.queue_free()
		if target.get_parent() == get_tree().current_scene.get_node("Launchers"):
			get_tree().current_scene.check_game_over()
		queue_free()
		return
	queue_redraw()

func _draw():
	draw_missile()

func draw_missile():
	#Main Body
	draw_rect(
		Rect2(-10,-68,20,68),
		Color(0.06,0.06,0.07)
	)
	draw_rect(
		Rect2(7,-68,2,68),
		Color(0.24,0.24,0.26)
	)
	
	draw_line(
		Vector2(0,-68),
		Vector2(0,0),
		Color(0.03,0.03,0.03),
		1
	)
	draw_rect(
		Rect2(-10,-52,20,4),
		Color(0.18,0.18,0.19)
	)
	draw_rect(
		Rect2(-10,-28,20,4),
		Color(0.18,0.18,0.19)
	)
	#War head
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-10,-68),
			Vector2(0,-92),
			Vector2(10,-68)
		]),
		Color(0.02,0.02,0.02)
	)
	draw_line(
		Vector2(-3,-82),
		Vector2(0,-90),
		Color(0.28,0.28,0.30),
		1
	)
	draw_circle(
		Vector2(0,-61),
		1.3,
		Color(1.0,0.55,0.08)
	)
	
	#Fins
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-10,-24),
			Vector2(-24,-8),
			Vector2(-10,2)
		]),
		Color(0.10,0.10,0.11)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(10,-24),
			Vector2(24,-8),
			Vector2(10,2)
		]),
		Color(0.10,0.10,0.11)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-8,0),
			Vector2(-16,10),
			Vector2(-8,10)
		]),
		Color(0.12,0.12,0.13)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(8,0),
			Vector2(16,10),
			Vector2(8,10)
		]),
		Color(0.12,0.12,0.13)
	)
	#Engine
	draw_rect(
		Rect2(-8,0,16,10),
		Color(0.03,0.03,0.03)
	)
	draw_rect(
		Rect2(-3,7,6,3),
		Color.BLACK
	)
	var bolt = Color(0.45,0.45,0.47)
	draw_circle(Vector2(-5,-46),1,bolt)
	draw_circle(Vector2(5,-46),1,bolt)
	draw_circle(Vector2(-5,-22),1,bolt)
	draw_circle(Vector2(5,-22),1,bolt)
	
	#flame
	
	var flame = 10.0 + sin(flame_flicker) * 3.0
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-3,10),
			Vector2(0,10 + flame),
			Vector2(3,10)
		]),
		Color(1.0,0.45,0.05)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-1.5,10),
			Vector2(0,6 + flame),
			Vector2(1.5,10)
		]),
		Color(1.0,0.95,0.55)
	)
func destroy():
	var explosion = EXPLOSION.instantiate()
	explosion.use_shockwave = false
	explosion.Start_radius = 10
	explosion.Min_radius = 8
	explosion.Max_radius = 24
	explosion.End_radius = 8
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	call_deferred("queue_free")
