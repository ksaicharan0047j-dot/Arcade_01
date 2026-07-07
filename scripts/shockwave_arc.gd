extends Node2D
 
const LIFE := 1.4
var timer := 0.0
var outer_radius := 122.0
var alpha := 1.0
var fade_alpha := 1.0
var current_color := Color.WHITE

func _ready():
	queue_redraw()

func _process(delta):
	timer += delta
	if timer >= LIFE:
		queue_free()
		return
	outer_radius += 45.0 * delta
	outer_radius += sin(timer * 18.0) * 0.15
	alpha = fade_alpha
	queue_redraw()

func _draw():
	var progress: float = clamp(timer / LIFE,0.0,1.0)
	var width = lerp(18.0,1.0,progress)
	draw_arc(
		Vector2.ZERO,
		outer_radius,
		deg_to_rad(205),
		deg_to_rad(335),
		64,
		Color(
			current_color.r,
			current_color.g,
			current_color.b,
			alpha
		),
		width,
		true
	)
