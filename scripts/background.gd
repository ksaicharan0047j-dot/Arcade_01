extends Node2D

func _draw():

	for y in range(0, 648, 40):

		draw_line(
			Vector2(0, y),
			Vector2(1152, y),
			Color(0.08, 0.08, 0.08)
		)

func _ready():
	queue_redraw()
