extends Node2D

@onready var cities = $Cities
@onready var launchers = $Launchers
const TARGET_SCENE = preload("res://scenes/target_marker.tscn")
var active_targets: Array[Node2D] = []

func _ready():
	randomize()
	place_cities()
	place_launchers()
func place_cities():
	var city_positions = [
		Vector2(245,610),
		Vector2(340,610),
		Vector2(435,610),
		Vector2(700,610),
		Vector2(800,610),
		Vector2(905,610)
	]
	for i in range(cities.get_child_count()):
		var city = cities.get_child(i)
		city.position = city_positions[i]

func place_launchers():
	var launcher_positions = [
		Vector2(140,576),
		Vector2(576,568),
		Vector2(1013,576)
	]
	for i in range(launchers.get_child_count()):
		var launcher = launchers.get_child(i)
		launcher.position = launcher_positions[i]

func _input(event):
	if event.is_action_pressed("click"):
		var target = TARGET_SCENE.instantiate()
		add_child(target)
		target.position = get_global_mouse_position()
		active_targets.append(target)
		print(active_targets.size())
