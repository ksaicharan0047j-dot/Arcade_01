extends Node2D

var stars = []

const STAR_COUNT = 170
const MOON_POSITION = Vector2(0.82, 95)
const MOON_CLEAR_RADIUS = 120.0

func _ready():
	randomize()
	var viewport = get_viewport_rect().size
	var sky_height = viewport.y * 0.90
	var moon_pos = Vector2(viewport.x * MOON_POSITION.x, MOON_POSITION.y)
	for i in range(STAR_COUNT):
		var pos = Vector2(
			randf_range(0, viewport.x),
			randf_range(0, sky_height)
		)
		# Fewer stars near the moon
		if pos.distance_to(moon_pos) < MOON_CLEAR_RADIUS and randf() < 0.6:
			continue
		var radius = randf_range(0.7, 2.0)
		var color : Color
		if radius < 0.9:
			color = Color(0.75, 0.82, 1.0)
		elif radius > 1.6:
			color = Color(1.0, 0.96, 0.88)
		else:
			color = Color.WHITE
		stars.append({
			"pos": pos,
			"radius": radius,
			"alpha": randf_range(0.25, 0.85),
			"base_alpha": randf_range(0.25, 0.85),
			"speed": randf_range(1.5, 4.0),
			"phase": randf() * TAU,
			"color": color
		})
func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0
	for star in stars:
		star.alpha = star.base_alpha + sin(time * star.speed + star.phase) * 0.18
		star.alpha = clamp(star.alpha, 0.15, 1.0)
	queue_redraw()
func _draw():
	var size = get_viewport_rect().size
	# Night Sky
	draw_rect(
		Rect2(Vector2.ZERO, size),
		Color(0.02, 0.02, 0.05)
	)
	# Stars
	for star in stars:
		var c = star.color
		c.a = star.alpha
		draw_circle(
			star.pos,
			star.radius,
			c
		)
