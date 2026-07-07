extends Node2D
const ENEMY_MISSILE = preload("res://scenes/enemy_missile.tscn")
@onready var enemy_launchers = $"../Launchers"
@onready var cities = $"../Cities"
@onready var game = get_parent()
var timer := 0.0
var interval := 2.0
func _process(delta):
	timer += delta
	if timer >= interval:
		timer = 0.0
		if game.missiles_spawned < game.missiles_this_wave:
			launch_enemy_missile()
			game.missiles_spawned += 1
func launch_enemy_missile():
	var alive_launchers = []
	for launcher in enemy_launchers.get_children():
		if is_instance_valid(launcher):
			alive_launchers.append(launcher)
	if alive_launchers.is_empty():
		return
	var launcher = alive_launchers[randi() % alive_launchers.size()]
	var possible_targets = []
	for city in cities.get_children():
		if is_instance_valid(city):
			possible_targets.append(city)
	for alive_launcher in alive_launchers:
		possible_targets.append(alive_launcher)
	if possible_targets.is_empty():
		return
	var target = possible_targets[randi() % possible_targets.size()]
	var missile = ENEMY_MISSILE.instantiate()
	missile.scale = Vector2(0.45,0.45)
	$"../EnemyMissiles".add_child(missile)
	missile.global_position = Vector2(launcher.global_position.x,-40)
	missile.target = target
	interval = randf_range(0.8,2.0)
