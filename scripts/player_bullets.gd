extends Node2D
var bullet_scene = preload("res://scenes/bullets_invaders.tscn")
func shoot(pos):
	var bullet = bullet_scene.instantiate()
	bullet.position = pos
	add_child(bullet)
