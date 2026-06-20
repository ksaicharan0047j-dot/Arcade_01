extends Node2D

var player_hp = 3
var enemy_hp = 3

func player_hit():
	player_hp -= 1
	print("PLAYER HP:",player_hp)
	if player_hp <= 0:
		print("YOU LOSE")

func enemy_hit():
	enemy_hp -= 1
	print("ENEMY HP:", enemy_hp)
	if enemy_hp <= 0:
		print("YOU WIN")
