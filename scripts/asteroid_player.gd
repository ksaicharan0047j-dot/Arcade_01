extends CharacterBody2D

var lanes = [350,450,550,650,750]
var lane_index = 2

func _ready():
	position = Vector2(lanes[lane_index],580)
	queue_redraw()

func _input(event):

	if event.is_action_pressed("ui_left"):
		lane_index -= 1

	if event.is_action_pressed("ui_right"):
		lane_index += 1

	lane_index = clamp(lane_index,0,4)

	position.x = lanes[lane_index]

func _draw():

	draw_polyline(
		[
			Vector2(0, -20),
			Vector2(-15, 15),
			Vector2(0, 8),
			Vector2(15, 15),
			Vector2(0, -20)
		],
		Color.WHITE,
		3
	)
