extends Node2D
var pipe_scene = preload("res://scenes/pipe.tscn")
var score = 0
@onready var score_label = $CanvasLayer/ScoreLabel
func _ready():
	randomize()
func _process(_delta):
	score_label.text = "SCORE: " + str(score)
	check_collisions()
func _on_spawn_timer_timeout():
	var gap_y = randf_range(180,500)
	var top_pipe = pipe_scene.instantiate()
	top_pipe.position = Vector2(1200,gap_y - 200)
	var bottom_pipe = pipe_scene.instantiate()
	bottom_pipe.position = Vector2(1200,gap_y + 200)
	$PipeContainer.add_child(top_pipe)
	$PipeContainer.add_child(bottom_pipe)
	score += 1
func check_collisions():
	var player = $FlappyPlayer
	if player.position.y > 648:
		game_over()
	for pipe in $PipeContainer.get_children():
		if abs(player.position.x - pipe.position.x) < 50 and abs(player.position.y - pipe.position.y) < 160:
			game_over()
func game_over():
	Global.final_flappy_score = score
	if score > Global.best_flappy_score:
		Global.best_flappy_score = score
	get_tree().change_scene_to_file("res://scenes/game_over_flappy.tscn")
