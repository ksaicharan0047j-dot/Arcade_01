extends Area2D
const SPEED = 500
func _ready():
	area_entered.connect(_on_area_entered)
	queue_redraw()
func _process(delta):
	position.y += SPEED * delta
	if position.y > 700:
		queue_free()
	queue_redraw()
func _draw():
	draw_rect(Rect2(-2,-6,4,12),Color.RED)
func _on_area_entered(area):
	if area.has_method("hit"):
		area.hit()
		queue_free()
