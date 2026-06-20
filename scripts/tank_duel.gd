extends Node2D

var player_hp = 3
var enemy_hp = 3
var timer = 0.0

@onready var player_hp_label = $UI/PlayerHPLabel
@onready var enemy_hp_label = $UI/EnemyHPLabel
@onready var timer_label = $UI/TimerLabel

func player_hit():
	player_hp -= 1
	print("PLAYER HP:",player_hp)
	if player_hp <= 0:
		game_over(false)
		print("YOU LOSE")

func enemy_hit():
	enemy_hp -= 1
	print("ENEMY HP:", enemy_hp)
	if enemy_hp <= 0:
		game_over(true)
		print("YOU WIN")
		
func _process(delta):
	timer += delta
	timer_label.text = ("TIME: "+str(snapped(timer, 0.01)))
	player_hp_label.text = "PLAYER: " + str(player_hp)
	enemy_hp_label.text = "ENEMY: " + str(enemy_hp)
	
func game_over(player_won):
	Global.final_time = timer
	Global.player_won = player_won
	get_tree().change_scene_to_file("res://scenes/game_over_tank_duel.tscn")
