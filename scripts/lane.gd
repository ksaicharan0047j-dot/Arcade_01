extends Node2D
var lane_type = "grass"
var lane_direction = 0
var car_scene = preload("res://scenes/car.tscn")
var boulder_scene = preload("res://scenes/boulder.tscn")
var world_score = 0
var path_center = -1
var path_width = 0
var blocked_cells = []
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
	elif world_score >= 10:
		spawn_boulders()
func spawn_cars():
	var cars_node = $Cars
	var car_count = randi_range(2,7)
	if world_score < 20:
		car_count = randi_range(2,4)
	elif world_score < 40:
		car_count = randi_range(3,5)
	elif world_score < 60:
		car_count = randi_range(4,6)
	else:
		car_count = randi_range(5,7)
	var lane_speed = min(150 + (world_score * 3),400)
	if lane_type == "left":
		lane_speed = -lane_speed
	var section = 1152.0 / car_count
	for i in range(car_count):
		var car = car_scene.instantiate()
		car.position.x = (i * section) + randf_range(-40,40)
		car.position.y = 20
		car.speed = lane_speed
		cars_node.add_child(car)
	print("Lane Score:", world_score)
	print("Lane Speed:", lane_speed)
func spawn_boulders():
	if randf() > 0.35:
		return
	var obstacle_node = $Obstacles
	for i in range(28):
		if abs(i - path_center) <= path_width:
			continue
		var boulder = boulder_scene.instantiate()
		boulder.position.x = 20 + (i * 40)
		boulder.position.y = 20
		obstacle_node.add_child(boulder)
		blocked_cells.append(i)
