extends Node2D
var bonus_scene = preload("res://scenes/bonus_ufo.tscn")
@onready var fleet = $EnemyFleet
@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel
@onready var level_label = $UI/LevelLabel
@onready var ufo_holder = $BonusUFO
@onready var bonus_timer = $BonusShipTimer
var score = 0
var level = 1
var lives = 3
var enemies_shooting = 1
var fire_rate = 1.5
func _ready():
	score_label.text = "Score: 0"
	level_label.text = "Level: 1"
	lives_label.text = "Lives: 3"
	fleet.fleet_cleared.connect(_on_fleet_cleared)
	bonus_timer.wait_time = randf_range(10.0,15.0)
	bonus_timer.start()
	bonus_timer.timeout.connect(_on_bonus_timer_timeout)
func add_score(points):
	score += points
	score_label.text = "score: " + str(score)
func _on_fleet_cleared():
	level += 1
	level_label.text = "Level: " + str(level)
	fire_rate = max(0.35, fire_rate - 0.08)
	enemies_shooting += 1
	await get_tree().process_frame
	fleet.spawn_fleet()
	fleet.get_node("DiveTimer").wait_time = max(1.0,5.0 - level * 0.15)
	$EnemyShootTimer.wait_time = fire_rate
	$EnemyShootTimer.start()
func _on_bonus_timer_timeout():
	var ufo = bonus_scene.instantiate()
	if randi() % 2 == 0:
		ufo.position = Vector2(1232,40)
		ufo.speed = 300
	else:
		ufo.position = Vector2(-80,40)
		ufo.speed = -300
	ufo.destroyed.connect(_on_ufo_destroyed)
	ufo_holder.add_child(ufo)
	bonus_timer.wait_time = randf_range(10.0,15.0)
	bonus_timer.start()
func _on_ufo_destroyed():
	add_score(100)
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_U:
		_on_bonus_timer_timeout()
func _on_enemy_shoot_timer_timeout():
	fleet.enemy_fire(enemies_shooting)
	$EnemyShootTimer.wait_time = fire_rate
	$EnemyShootTimer.start()
