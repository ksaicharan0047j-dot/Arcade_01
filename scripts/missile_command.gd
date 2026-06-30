extends Node2D

@onready var cities = $Cities
@onready var launchers = $Launchers
const TARGET_SCENE = preload("res://scenes/target_marker.tscn")
const PLAYER_MISSILE_SCENE = preload("res://scenes/player_missile.tscn")
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
		launcher.launcher_type = i
		launcher.turret.launcher_type = i
		launcher.turret.queue_redraw()

func _input(event):
	if event.is_action_pressed("click"):
		var target = TARGET_SCENE.instantiate()
		add_child(target)
		target.position = get_global_mouse_position()
		active_targets.append(target)
		assign_target(target)

func assign_target(target: Node2D):
	var x = target.position.x
	var launcher
	var screen_width = get_viewport_rect().size.x
	var third = screen_width / 3.0
	if x < third:
		launcher = launchers.get_child(0)
	elif x < third * 2:
		launcher = launchers.get_child(1)
	else:
		launcher = launchers.get_child(2)
	launcher.target = target
	launcher_player_missile(launcher,target)

func launcher_player_missile(launcher, target):
	var missile = PLAYER_MISSILE_SCENE.instantiate()
	missile.scale = Vector2(0.35,0.35)
	$PlayerMissiles.add_child(missile)
	missile.global_position = launcher.turret.global_position
	missile.target = target
