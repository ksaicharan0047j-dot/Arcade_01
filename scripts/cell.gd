extends Node2D

const CELL_SIZE = 32
var grid_position = Vector2i()

var is_mine = false
var revealed = false
var flagged = false
var neighbour_count = 0

func _ready():
	queue_redraw()

func _draw():
	var fill = Color(0.8,0.8,0.8)
	if revealed:
		fill = Color.WHITE
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(CELL_SIZE,CELL_SIZE)),
		fill
	)
	draw_rect(
		Rect2(Vector2.ZERO,Vector2(CELL_SIZE,CELL_SIZE)),
		Color.BLACK,
		false,
		2
	)
	if flagged:
		draw_string(
			ThemeDB.fallback_font,
			Vector2(9,24),
			"F",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			18,
			Color.RED
		)
	elif revealed:
		if is_mine:
			draw_circle(
				Vector2(16,16),
				6,
				Color.BLACK
			)
		elif neighbour_count > 0:
			draw_string(
				ThemeDB.fallback_font,
				Vector2(11,24),
				str(neighbour_count),
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				18,
				Color.BLACK
			)
