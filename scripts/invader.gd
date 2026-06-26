extends Area2D
var diving = false
var dive_speed = 350
signal died
func _ready():
	queue_redraw()
func _process(delta):
	if diving:
		position.y += dive_speed * delta
	queue_redraw()
func _draw():
	draw_rect(Rect2(-12,-8,24,16),Color.LIME_GREEN)
	draw_rect(Rect2(-7,-4,3,3),Color.BLACK)
	draw_rect(Rect2(4,-4,3,3),Color.BLACK)
	draw_rect(Rect2(-10,8,4,4),Color.LIME_GREEN)
	draw_rect(Rect2(6,8,4,4),Color.LIME_GREEN)
func die():
	died.emit()
	queue_free()
func start_dive():
	diving = true
