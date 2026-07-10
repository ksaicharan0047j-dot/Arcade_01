extends Node2D

var wave := 1
var missiles_this_wave := 10
var missiles_spawned := 0
var wave_running := false
@onready var cities = $Cities
@onready var launchers = $Launchers

const TARGET_SCENE = preload("res://scenes/target_marker.tscn")
const PLAYER_MISSILE_SCENE = preload("res://scenes/player_missile.tscn")
const CITY_SCENE = preload("res://scenes/city.tscn")
const GAME_Over_Scene = preload("res://scenes/game_over_missile_command.tscn")



func _ready():
	randomize()
	place_cities()
	place_launchers()
	start_wave()

func _process(_delta):
	if !wave_running:
		return
	if missiles_spawned >= missiles_this_wave and $EnemyMissiles.get_child_count() == 0:
		wave_running = false
		end_wave()

func place_cities():
	var city_positions = [
		Vector2(245,610),
		Vector2(340,610),
		Vector2(435,610),
		Vector2(700,610),
		Vector2(800,610),
		Vector2(905,610)
	]

	for i in range(min(cities.get_child_count(), city_positions.size())):
		cities.get_child(i).position = city_positions[i]

func place_launchers():
	var launcher_positions = [
		Vector2(140,576),
		Vector2(576,568),
		Vector2(1013,576)
	]

	for i in range(min(launchers.get_child_count(), launcher_positions.size())):
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
		assign_target(target)

func assign_target(target: Node2D):

	if launchers.get_child_count() == 0:
		target.queue_free()
		return

	var closest_launcher = null
	var closest_distance = INF

	for launcher in launchers.get_children():
		if launcher.missiles_left <= 0:
			continue

		var distance = abs(target.position.x - launcher.position.x)

		if distance < closest_distance:
			closest_distance = distance
			closest_launcher = launcher

	if closest_launcher == null:
		target.queue_free()
		return

	closest_launcher.targets.append(target)

func launcher_player_missile(launcher, target):
	var missile = PLAYER_MISSILE_SCENE.instantiate()

	missile.scale = Vector2(0.35,0.35)

	$PlayerMissiles.add_child(missile)

	missile.global_position = launcher.turret.get_node("MissileSpawn").global_position

	missile.target = target

func start_wave():
	print("wave completed!")

	missiles_spawned = 0
	wave_running = true
	
	$EnemyMissileCommand.interval = max(0.45,2.0 - wave * 0.12)
	for launcher in launchers.get_children():
		launcher.missiles_left = launcher.MAX_MISSILES

func end_wave():
	wave_running = false
	print("Wave Completed!")
	var screen = preload("res://scenes/wave_complete.tscn").instantiate()

	add_child(screen)
	screen.cities_saved = cities.get_child_count()
	screen.launchers_left = launchers.get_child_count()
	screen.missiles_left = count_remaining_missiles()
	screen.bonus = calculate_bonus()

	screen.show_results()

	await screen.tree_exited
	rebuild_cities()
	wave += 1
	missiles_this_wave += 5
	start_wave()

func count_remaining_missiles() -> int:
	var total := 0
	for launcher in launchers.get_children():
		if is_instance_valid(launcher):
			total += launcher.missiles_left
	return total

func calculate_bonus() -> int:
	var cities_saved := cities.get_child_count()
	var launchers_left := launchers.get_child_count()
	var missiles_left := count_remaining_missiles()
	return (
		cities_saved * 100 + 
		launchers_left * 200 + 
		missiles_left * 10 +
		wave * 500 
	)

func rebuild_cities():
	var city_positions = [
		Vector2(245,610),
		Vector2(340,610),
		Vector2(435,610),
		Vector2(700,610),
		Vector2(800,610),
		Vector2(905,610)
	]
	
	for city in cities.get_children():
		city.queue_free()
	for pos in city_positions:
		var city = CITY_SCENE.instantiate()
		cities.add_child(city)
		city.position = pos

func check_game_over():
	if launchers.get_child_count() == 0:
		game_over()

func game_over():
	wave_running = false
	var scene = GAME_Over_Scene.instantiate()
	
	add_child(scene)
	scene.wave = wave
	scene.score = calculate_bonus()
	scene.show_results()
