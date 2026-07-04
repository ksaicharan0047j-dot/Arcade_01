extends Node2D

const Shrink_time := 0.20
const Expand_time := 2.20
const Hold_time := 0.30
const Collapse_time := 1.20
const Fade_time := 0.50

const Start_radius := 28.0
const Min_radius := 20.0
const Max_radius := 120.0
const End_radius := 40.0

var timer := 0.0
var radius := Start_radius
var alpha := 1.0
var blast_color := Color.WHITE
var palette = [
	Color.WHITE,
	Color(0.75,0.95,1.00),
	Color(0.10,0.95,1.00),
	Color(0.10,0.45,1.00),
	Color(0.65,0.20,1.00),
	Color(1.00,0.20,0.90)
]

var arc_triggered := false
var shockwave = null

func  _process(delta):
	timer += delta
	var speed := 2.0
	var phase := timer * speed
	var index := int(floor(phase)) % palette.size()
	var next := (index + 1) % palette.size()
	var blend :float= phase - floor(phase)
	blast_color = palette[index].lerp(
		palette[next],
		blend
	)
	if timer < Shrink_time:
		var t  = timer / Shrink_time
		radius = lerp(Start_radius,Min_radius,t)
		alpha = 1.0
	elif timer < Shrink_time + Expand_time:
		var t = (timer - Shrink_time) / Expand_time
		radius = lerp(Min_radius, Max_radius,t)
		alpha = 1.0
		
		if !arc_triggered and radius >= Max_radius - 1.0:
			arc_triggered = true
			shockwave = preload("res://scenes/shockwave_arc.tscn").instantiate()
			get_parent().add_child(shockwave)
			shockwave.global_position = global_position
			shockwave.outer_radius = radius - 10.0
	elif timer <Shrink_time + Expand_time + Hold_time + Collapse_time:
		var t = (timer - Shrink_time - Expand_time - Hold_time) / Collapse_time
		radius = lerp(Max_radius,End_radius,t)
		alpha = 1.0
	else:
		var t = (timer - Shrink_time - Expand_time - Hold_time - Collapse_time) / Fade_time
		alpha = 1.0 - clamp(t,0.0,1.0)
		if alpha <= 0.0:
			queue_free()
	if shockwave != null:
		shockwave.fade_alpha = alpha
		shockwave.current_color = blast_color
	queue_redraw()

func _draw():
	# Main blast
	draw_circle(
		Vector2.ZERO,
		radius,
		Color(
			blast_color.r,
			blast_color.g,
			blast_color.b,
			alpha
		)
	)
