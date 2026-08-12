extends Area2D

const VALUE := 10

# Colors
const OUTER_COLOR := Color(0.85, 0.65, 0.08)
const MAIN_COLOR := Color(1.0, 0.85, 0.2)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 0.75)
const SHADOW_COLOR := Color(0, 0, 0, 0.35)

# Size
const PELLET_RADIUS := 4.0

# Animation
const BOUNCE_HEIGHT := 1.5
const BOUNCE_SPEED := 3.0

var animation_time := 0.0


func _ready():

	# Give every pellet a different animation phase
	animation_time = randf_range(0.0, TAU)

	queue_redraw()


func _process(delta):

	animation_time += delta * BOUNCE_SPEED

	queue_redraw()


func _draw():

	# Small jumping motion
	var bounce := sin(animation_time) * BOUNCE_HEIGHT

	# Shadow underneath
	draw_pellet_shadow(
		Vector2(0, 4),
		Vector2(4.0, 1.5),
		SHADOW_COLOR
	)

	# Dark outer edge
	draw_circle(
		Vector2(0, bounce),
		PELLET_RADIUS + 0.8,
		OUTER_COLOR
	)

	# Main pellet
	draw_circle(
		Vector2(0, bounce - 0.5),
		PELLET_RADIUS,
		MAIN_COLOR
	)

	# Tiny highlight
	draw_circle(
		Vector2(-1.2, bounce - 1.5),
		1.1,
		HIGHLIGHT_COLOR
	)


# Custom name so it doesn't conflict with Godot
func draw_pellet_shadow(
	position: Vector2,
	radius: Vector2,
	color: Color
):

	var points := PackedVector2Array()

	for i in range(20):

		var angle := TAU * float(i) / 20.0

		points.append(
			position + Vector2(
				cos(angle) * radius.x,
				sin(angle) * radius.y
			)
		)

	draw_colored_polygon(points, color)


func _on_body_entered(body):

	if body.name == "PacmanPlayer":

		var game = get_tree().current_scene

		if game.has_method("add_score"):
			game.add_score(VALUE)

		queue_free()
