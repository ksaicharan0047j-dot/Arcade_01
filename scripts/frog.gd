extends CharacterBody2D
var step_size = 40
func _ready():
	queue_redraw()
func _draw():
	draw_rect(Rect2(-10,-10,20,20),Color.RED)
func _process(_delta):
	queue_redraw()
func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		position.y -= step_size
		get_parent().frog_moved_up()
	if event.is_action_pressed("ui_down"):
		position.y += step_size
	if event.is_action_pressed("ui_left"):
		position.x -= step_size
	if event.is_action_pressed("ui_right"):
		position.x += step_size
