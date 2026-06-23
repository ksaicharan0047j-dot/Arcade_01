extends AnimatableBody2D

var rest_rotation = deg_to_rad(-20)
var flip_rotation = deg_to_rad(-80)
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rotation = lerp_angle(rotation,flip_rotation,50.0 * delta)
	else:
		rotation = lerp_angle(rotation,rest_rotation,50.0 * delta)
func _draw():
	draw_rect(Rect2(0,-5,120,10),Color.WHITE)
func _ready():
	queue_redraw()
