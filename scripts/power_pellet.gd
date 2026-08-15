extends Area2D

const VALUE := 50

const MAIN_COLOR := Color(1.0, 0.8, 0.1)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 0.7)
const RADIUS := 8.0

func _ready():
	queue_redraw()

func _draw():
	draw_circle(
		Vector2(1.5, 3.0),
		RADIUS * 0.9,
		Color(0.0, 0.0, 0.0, 0.3)
	)

	draw_circle(
		Vector2.ZERO,
		RADIUS,
		MAIN_COLOR
	)

	draw_circle(
		Vector2(-2.0, -2.5),
		2.0,
		HIGHLIGHT_COLOR
	)

func _on_body_entered(body):
	if body.name == "PacmanPlayer":

		print("POWER PELLET TOUCHED BY: ", body.name)

		var game = get_tree().current_scene

		if game.has_method("add_score"):
			game.add_score(VALUE)

		if body.has_method("activate_power_mode"):
			body.activate_power_mode()
			print("PAC-MAN POWER MODE ACTIVATED DIRECTLY!")

		if game.has_method("active_power_mode"):
			game.active_power_mode()

		queue_free()
