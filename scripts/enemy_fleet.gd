extends Node2D
@onready var dive_timer = $DiveTimer
var enemy_scene = preload("res://scenes/invader.tscn")
var bullet_scene = preload("res://scenes/enemy_bullet.tscn")
var direction = 1
signal fleet_cleared
var enemies_left = 0
const SPEED = 60
const ROWS = 4
const COLS = 10
const X_SPACING = 70
const Y_SPACING = 55
func _ready():
	spawn_fleet()
	$DiveTimer.start()
	print("Timer Started")
func spawn_fleet():
	enemies_left = ROWS * COLS
	for child in get_children():
		if child.name == "DiveTimer":
			continue
		child.queue_free()
	for row in ROWS:
		for col in COLS:
			var enemy = enemy_scene.instantiate()
			enemy.position = Vector2(col * X_SPACING,row * Y_SPACING)
			enemy.died.connect(_on_enemy_died)
			add_child(enemy)
	position = Vector2(260,80)
func _process(delta):
	position.x += SPEED * direction * delta
	if position.x < 40:
		direction = 1
		position.y += 25
	elif position.x > 480:
		direction = -1
		position.y += 25
func random_enemy():
	var alive = []
	for child in get_children():
		if child.has_method("start_dive"):
			alive.append(child)
		alive.append(child)
	if alive.is_empty():
		return null
	return alive.pich_random()
func start_random_dive():
	var alive = []
	for child in get_children():
		if child.has_method("start_dive"):
			alive.append(child)
	if alive.is_empty():
		return
	var enemy = alive.pick_random()
	enemy.start_dive()

func _on_dive_timer_timeout():
	print("TIMER")
	start_random_dive()
	$DiveTimer.wait_time = randf_range(5.0,10.0)
func _on_enemy_died():
	enemies_left -= 1
	get_parent().add_score(10)
	if enemies_left <= 0:
		fleet_cleared.emit()
func enemy_fire(amount):
	var shooters = []
	for child in get_children():
		if child.has_method("start_dive"):
			shooters.append(child)
	shooters.shuffel()
	amount = min(amount,shooters.size())
	for i in range(amount):
		var bullet = bullet_scene.instantiate()
		bullet.position = shooters[i].global_position + Vector2(0,20)
		get_parent().get_node("EnemyBullets").add_child(bullet)
