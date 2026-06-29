extends Node2D

var moon_pos : Vector2
const MOON_RADIUS = 36

var pulse := 0.0
var moon_texture_points = []


func _ready():
	var w = get_viewport_rect().size.x
	moon_pos = Vector2(w * 0.82,95)
	#generate moon texture once...
	for i in range(250):
		var angle = randf() * TAU
		var dist = pow(randf(), 0.65) * (MOON_RADIUS - 3)
		moon_texture_points.append({
			"pos": Vector2.RIGHT.rotated(angle) * dist,
			"radius": randf_range(0.5,1.4),
			"brightness": randf_range(0.82,0.95),
			"alpha": randf_range(0.03,0.09)
		})
	
func _process(delta):
	pulse += delta
	queue_redraw()

func _draw():
	draw_glow()
	draw_moon()
	
func draw_glow():
	var breathe = (sin(pulse * 0.25) + 1.0) * 0.5
	for i in range(50):
		var radius = MOON_RADIUS + 12 + i * 3
		var alpha = 0.018 * pow(1.0 - float(i)/50.0, 3.5)
		alpha *= 0.95 + breathe * 0.1
		draw_circle(
			moon_pos,
			radius,
			Color(0.93,0.94,1.0,alpha)
		)

func draw_moon():
	# Main body
	draw_circle(
		moon_pos,
		MOON_RADIUS,
		Color(0.92,0.92,0.90)
	)
	# moon maria 
	var patches = [
		{"pos": Vector2(-10,-6), "r": 10.0},
		{"pos": Vector2(8,8), "r": 8.0},
		{"pos": Vector2(-2,14), "r": 6.0}
	]
	for patch in patches:
		draw_circle(
			moon_pos + patch.pos,
			patch.r,
			Color(0.84,0.84,0.84,0.22)
		)
	# Soft rim
	draw_arc(
		moon_pos,
		MOON_RADIUS,
		0,
		TAU,
		120,
		Color(1,1,1,0.18),
		2
	)
	for point in moon_texture_points:
		draw_circle(
			moon_pos + point.pos,
			point.radius,
			Color(
				point.brightness,
				point.brightness,
				point.brightness,
				point.alpha 
			)
		)
		#small crater
		var craters = [
			{"pos": Vector2(-14,-12), "r": 3.5},
			{"pos": Vector2(13,-8), "r": 2.5},
			{"pos": Vector2(9,14), "r": 1.8}
		]
		for crater in craters:
			draw_arc(
				moon_pos + crater.pos,
				crater.r,
				0,
				TAU,
				24,
				Color(0.72,0.72,0.72,0.35),
				1
			)
		draw_arc(
			moon_pos,
			MOON_RADIUS,
			deg_to_rad(210),
			deg_to_rad(330),
			48,
			Color(1,1,1,0.18),
			1
		)
