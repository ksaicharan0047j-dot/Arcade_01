extends Node2D

var stars = []
func _ready():
	randomize()
	for i in range(120):
		stars.append({
			"pos": Vector2(
				randf_range(0, get_viewport_rect().size.x),
				randf_range(0,420)
			),
			"radius": randf_range(1.0, 2.5),
			"alpha": randf_range(0.4, 1.0),
			"speed": randf_range(2.0, 5.0)
		})

func _process(delta):
	for star in stars:
		star.alpha += sin(Time.get_ticks_msec() / 1000.0 * star.speed) * delta
		star.alpha = clamp(star.alpha, 0.2, 1.0)
	queue_redraw()

func _draw():
	var size = get_viewport_rect().size
	
	#sky
	draw_rect(
		Rect2(Vector2.ZERO, size),
		Color(0.02, 0.02,0.05)
	)
	#Stars
	for star in stars:
		draw_circle(
			star.pos,
			star.radius,
			Color(1,1,1,star.alpha)
		)
