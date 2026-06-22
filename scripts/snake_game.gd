extends Node2D

const GRID_SIZE = 10
const CELL_SIZE = 50

var snake = [Vector2i(5,5)]
var direction = Vector2i.RIGHT
var next_direction = Vector2i.RIGHT

var food = Vector2i(2,2)
var score = 0
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var best_label = $CanvasLayer/BestLabel
func _ready():
	randomize()
	spawn_food()
	queue_redraw()
func _process(_delta):
	score_label.text = "SCORE: " + str(score)
	best_label.text = "BEST: " + str(Global.best_snake_score)
func _input(event):
	if event.is_action_pressed("ui_up") and direction != Vector2i.DOWN:
		next_direction = Vector2i.UP
	if event.is_action_pressed("ui_down") and direction != Vector2i.UP:
		next_direction = Vector2i.DOWN
	if event.is_action_pressed("ui_left") and direction != Vector2i.LEFT:
		next_direction = Vector2i.LEFT
	if event.is_action_pressed("ui_right") and direction != Vector2i.RIGHT:
		next_direction = Vector2i.RIGHT
func _on_move_timer_timeout():
	direction = next_direction
	var head = snake[0] + direction
	 #Wall collision
	if head.x < 0 or head.x >= GRID_SIZE:
		game_over()
		return
	if head.y < 0 or head.y >= GRID_SIZE:
		game_over()
		return
	
	#self collision
	if head in snake:
		game_over()
		return
	snake.insert(0,head)
	
	#food eat
	if head == food:
		score += 1
		if score > Global.best_snake_score:
			Global.best_snake_score = score
		spawn_food()
	else:
		snake.pop_back()
	queue_redraw()
func spawn_food():
	while true:
		var pos = Vector2i(randi() % GRID_SIZE, randi() % GRID_SIZE)
		if !(pos in snake):
			food = pos
			return
func game_over():
	Global.final_snake_score = score
	get_tree().change_scene_to_file("res://scenes/game_over_snake.tscn")
func _draw():
	# grid
	for x in range(GRID_SIZE + 1):
		draw_line(Vector2(x * CELL_SIZE,0),Vector2(x * CELL_SIZE, GRID_SIZE * CELL_SIZE), Color.DARK_GRAY)
	for y in range(GRID_SIZE + 1):
		draw_line(Vector2(0,y * CELL_SIZE),Vector2(GRID_SIZE * CELL_SIZE, y * CELL_SIZE), Color.DARK_GRAY)
	#food
	draw_rect(Rect2(food.x * CELL_SIZE, food.y * CELL_SIZE,CELL_SIZE,CELL_SIZE),Color.WHITE)
	#snake body
	for segment in snake:
		draw_rect(Rect2(segment.x * CELL_SIZE,segment.y * CELL_SIZE,CELL_SIZE,CELL_SIZE),Color.WHITE)
