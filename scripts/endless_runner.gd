extends Node2D

@onready var obstacles = $Obstacles
@onready var birds = $Birds

var obstacle_scene = preload("res://scenes/obstacle_runner.tscn")
var bird_scene = preload("res://scenes/bird_runner.tscn")

var score = 0
var level = 1
var game_over = false
var is_night = false
var game_speed = 350.0
var difficulty = 0
var last_cycle = 0
var stars = []

func _ready():
	$SpawnTimer.wait_time = randf_range(1.2,2.4)
	$SpawnTimer.start()
	$ScoreTimer.start()
	if score >= 300:
		$BirdTimer.start()
	randomize()
	for i in range(40):
		stars.append(
			Vector2(
				randf_range(20,get_viewport_rect().size.x - 20),randf_range(20,220))
		)
func _process(_delta):
	pass

func _on_spawn_timer_timeout():
	if game_over:
		return
	var count = 1
	if score >= 200:
		count = [1,2,3].pick_random()
	elif score >= 100:
		count = [1,1,2].pick_random()
	for i in range(count):
		var obstacle = obstacle_scene.instantiate()
		obstacle.is_night = is_night
		obstacle.speed = game_speed
		obstacle.position = Vector2(
			get_viewport_rect().size.x + 30 + i * 40,
			529
		)
		$Obstacles.add_child(obstacle)
	$SpawnTimer.wait_time = randf_range(0.7,2.4)
	$SpawnTimer.start()
func _on_score_timer_timeout():
	if game_over:
		return
	score += 1 + difficulty 
	var new_difficulty = score / 100
	if new_difficulty > difficulty:
		difficulty = new_difficulty
		game_speed += 40
	var cycle = score / 300
	if cycle > last_cycle:
		last_cycle = cycle
		toggle_day_night()
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)
	if score >= 300 and $BirdTimer.is_stopped():
		$BirdTimer.start()

func _on_bird_timer_timeout():
	if game_over:
		return
	var bird = bird_scene.instantiate()
	bird.is_night = is_night
	bird.speed = game_speed
	var heights = [430,470]
	bird.position = Vector2(
		get_viewport_rect().size.x + 40,
		heights.pick_random()
	)
	$Birds.add_child(bird)
	$BirdTimer.wait_time = randf_range(3.0,7.0)
	$BirdTimer.start()

func toggle_day_night():
	is_night = !is_night
	$GroundRunner.queue_redraw()
	$PlayerRunner.queue_redraw()
	for obstacle in $Obstacles.get_children():
		obstacle.is_night = is_night
	for bird in $Birds.get_children():
		bird.is_night = is_night
	queue_redraw()
	$PlayerRunner.queue_redraw()
	$GroundRunner.queue_redraw()
	for obstacle in $Obstacles.get_children():
		obstacle.queue_redraw()
	for bird in $Birds.get_children():
		bird.queue_redraw()
	$PlayerRunner.is_night = is_night
	print("Player night =", $PlayerRunner.is_night)
	$PlayerRunner.queue_redraw()
	var ui_color = Color.BLACK
	if is_night:
		ui_color = Color.WHITE
	$CanvasLayer/ScoreLabel.modulate = ui_color

func _draw():
	if is_night:
		draw_rect(
			Rect2(Vector2.ZERO,get_viewport_rect().size),
			Color.BLACK
		)
		for star in stars:
			draw_circle(star,2,Color.WHITE)
	else:
		draw_rect(
			Rect2(Vector2.ZERO,get_viewport_rect().size),
			Color.WHITE
		)
	draw_circle(Vector2(get_viewport_rect().size.x - 120,80),28,Color.WHITE)

func end_game():
	if game_over:
		return
	game_over = true
	$SpawnTimer.stop()
	$BirdTimer.stop()
	$ScoreTimer.stop()
	$CanvasLayer/GameOverPanel.visible = true

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
