extends Area2D

const VALUE := 10

const OUTER_COLOR := Color(0.85, 0.65, 0.08)
const MAIN_COLOR := Color(1.0, 0.85, 0.2)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 0.75)
const SHADOW_COLOR := Color(0.0, 0.0, 0.0, 0.35)

const PELLET_RADIUS := 4.0


func _ready():
	queue_redraw()


func _draw():

	# Small shadow underneath the pellet
	draw_circle(
		Vector2(1.0, 3.5),
		3.2,
		SHADOW_COLOR
	)

	# Dark outer edge
	draw_circle(
		Vector2.ZERO,
		PELLET_RADIUS + 0.8,
		OUTER_COLOR
	)

	# Main pellet
	draw_circle(
		Vector2.ZERO,
		PELLET_RADIUS,
		MAIN_COLOR
	)

	# Tiny highlight
	draw_circle(
		Vector2(-1.2, -1.5),
		1.1,
		HIGHLIGHT_COLOR
	)


func _on_body_entered(body):

	if body.name == "PacmanPlayer":

		var game = get_tree().current_scene

		if game.has_method("add_score"):
			game.add_score(VALUE)

		queue_free()
