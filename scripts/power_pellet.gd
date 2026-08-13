extends Area2D

const VALUE := 50

# Size
const RADIUS := 8.0

# Colors
const OUTER_COLOR := Color(0.85, 0.55, 0.05)
const MAIN_COLOR := Color(1.0, 0.85, 0.2)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 0.8)
const SHADOW_COLOR := Color(0.0, 0.0, 0.0, 0.35)

# Animation
const BOUNCE_HEIGHT := 2.5
const BOUNCE_SPEED := 3.5

var animation_time := 0.0


func _ready():

	# Random starting point
	animation_time = randf_range(0.0, TAU)

	queue_redraw()


func _process(delta):

	animation_time += delta * BOUNCE_SPEED

	queue_redraw()


func _draw():

	# Small jumping motion
	var bounce := sin(animation_time) * BOUNCE_HEIGHT

	# Shadow
	draw_circle(
		Vector2(0, 9),
		6.0,
		SHADOW_COLOR
	)

	# Outer body
	draw_circle(
		Vector2(0, bounce),
		RADIUS + 1.2,
		OUTER_COLOR
	)

	# Main body
	draw_circle(
		Vector2(0, bounce - 1.0),
		RADIUS,
		MAIN_COLOR
	)

	# Highlight
	draw_circle(
		Vector2(-2.5, bounce - 3.0),
		2.0,
		HIGHLIGHT_COLOR
	)


func _on_body_entered(body):

	print("POWER PELLET TOUCHED BY: ", body.name)

	if body.name == "PacmanPlayer":

		print("PACMAN ATE POWER PELLET!")

		var game = get_tree().current_scene

		print("CURRENT SCENE: ", game.name)
		print(
			"HAS POWER FUNCTION: ",
			game.has_method("activate_power_mode")
		)

		if game.has_method("add_score"):
			game.add_score(VALUE)

		if game.has_method("activate_power_mode"):
			game.activate_power_mode()

		queue_free()
