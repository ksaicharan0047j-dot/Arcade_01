extends Area2D

var speed := 300.0

func _process(delta):
	position.y += speed * delta

	if position.y > 700:
		queue_free()

func _draw():
	draw_rect(
		Rect2(-15, -15, 30, 30),
		Color.WHITE
	)

func _ready():
	queue_redraw()
