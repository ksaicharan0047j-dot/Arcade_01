extends Node2D
@onready var dive_timer = $DiveTimer
var enemy_scene = preload("res://scenes/invader.tscn")
var direction = 1
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
	for child in get_children():
		if child.name == "DiveTimer":
			continue
		child.queue_free()
	for row in ROWS:
		for col in COLS:
			var enemy = enemy_scene.instantiate()
			enemy.position = Vector2(col * X_SPACING,row * Y_SPACING)
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
	var alive = get_children()
	if alive.is_empty():
		return null
	return alive.pick_random()
func start_random_dive():
	var alive = get_children()
	print("Enemies:",alive.size())
	if alive.is_empty():
		return
	var enemy = alive.pick_random()
	print("Chosen:",enemy.name)
	enemy.start_dive()

func _on_dive_timer_timeout():
	print("TIMER")
	start_random_dive()
	$DiveTimer.wait_time = randf_range(5.0,10.0)
