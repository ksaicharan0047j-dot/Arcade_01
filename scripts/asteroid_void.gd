extends Node2D

var asteroid_scene = preload("res://scenes/Asteroid.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

func _on_spawn_timer_timeout():

	var asteroid = asteroid_scene.instantiate()

	asteroid.position = Vector2(randf_range(20, 1130), -30)

	add_child(asteroid)
