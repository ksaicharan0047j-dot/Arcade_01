extends Node2D

var player_score = 0
var ai_score = 0
@onready var player_label = $CanvasLayer/PlayerScore
@onready var ai_label = $CanvasLayer/AIScore
func _process(_delta):
	player_label.text = str(player_score)
	ai_label.text = str(ai_score)
func player_scored_player():
	player_score += 1
	$Ball.position = Vector2(576,324)
	$Ball.ball_velocity = Vector2(-400,250)
	check_winner()
func player_scored_ai():
	ai_score += 1
	$Ball.position = Vector2(576,324)
	$Ball.ball_velocity = Vector2(400,250)
	check_winner()
func check_winner():

	if player_score >= 5:

		Global.pong_winner = "PLAYER"
		Global.pong_player_score = player_score
		Global.pong_ai_score = ai_score

		get_tree().change_scene_to_file(
			"res://scenes/game_over_pong.tscn"
		)

	if ai_score >= 5:

		Global.pong_winner = "AI"
		Global.pong_player_score = player_score
		Global.pong_ai_score = ai_score

		get_tree().change_scene_to_file(
			"res://scenes/game_over_pong.tscn"
		)
