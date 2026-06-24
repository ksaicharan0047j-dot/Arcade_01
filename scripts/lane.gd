extends Node2D
var lane_type = "grass"
var lane_direction = 0
var car_scene = preload("res://scenes/car.tscn")
var world_score = 0
func _draw():
	if lane_type == "grass":
		draw_rect(Rect2(0,0,1152,40),Color.DARK_GREEN)
	elif lane_type == "left":
		draw_rect(Rect2(0,0,1152,40),Color.DIM_GRAY)
	elif lane_type == "right":
		draw_rect(Rect2(0,0,1152,40),Color.DIM_GRAY)
	draw_line(Vector2(0,0),Vector2(1152,0),Color.WHITE,2)
func _ready():
	queue_redraw()
	if lane_type != "grass":
		spawn_cars()
func spawn_cars():
	var cars_node = $Cars
	var car_count = randi_range(1,7)
	var current_x = randf_range(0,50)
	for i in range(car_count):
		var car = car_scene.instantiate()
		car.position.x = current_x
		car.position.y = 20
		var speed = min(150 + (world_score * 3), 400)
		if lane_type == "left":
			car.speed = -150
		else:
			car.speed = 150
		cars_node.add_child(car)
		current_x += randf_range(60,100)
