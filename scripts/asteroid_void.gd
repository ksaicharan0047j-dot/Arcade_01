extends Node2D

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var score := 0.0
var survival_time := 0.0

@onready var spawn_timer = $SpawnTimer
@onready var score_label = $ScoreLabel
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	queue_redraw()
	
func _process(delta):
	score += delta
	score_label.text = "Score: " + str(int(score))
	survival_time += delta
	if survival_time > 60:
		spawn_timer.wait_time = 0.20
	elif survival_time > 30:
		spawn_timer.wait_time = 0.35
	elif survival_time > 15:
		spawn_timer.wait_time = 0.50
	else:
		spawn_timer.wait_time = 0.80

func _on_spawn_timer_timeout():

	var asteroid = asteroid_scene.instantiate()

	var lanes = [350,450,550,650,750]
	asteroid.position = Vector2(lanes[randi() % 5], -30)

	add_child(asteroid)
func _draw():

	draw_line(Vector2(300,0), Vector2(300,648), Color.WHITE)
	draw_line(Vector2(400,0), Vector2(400,648), Color.WHITE)
	draw_line(Vector2(500,0), Vector2(500,648), Color.WHITE)
	draw_line(Vector2(600,0), Vector2(600,648), Color.WHITE)
	draw_line(Vector2(700,0), Vector2(700,648), Color.WHITE)
	draw_line(Vector2(800,0), Vector2(800,648), Color.WHITE)
