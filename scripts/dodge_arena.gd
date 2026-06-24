extends Node2D
var enemy_scene = preload("res://scenes/enemy.tscn")
var lives = 3
var score = 0
@onready var spawn_timer = $SpawnTimer
@onready var player = $PlayerDodge
@onready var enemies = $Enemies
func _on_spawn_timer_timeout():
	for i in range(3):
		var enemy = enemy_scene.instantiate()
		var side = randi() % 4
		match side:
			0:
				enemy.position = Vector2(randf_range(0,1152),-20)
			1:
				enemy.position = Vector2(randf_range(0,1152),668)
			2:
				enemy.position = Vector2(-10,randf_range(0,648))
			3:
				enemy.position = Vector2(1172,randf_range(0,648))
		enemy.target = player
		enemies.add_child(enemy)
func player_hit():
	print("PLAYER HIT")
	lives -= 1
	print("LIVES:", lives)
	$LivesLabel.text = "LIVES: " + str(lives)
	if lives <= 0:
		get_tree().reload_current_scene()


func _on_score_timer_timeout() -> void:
	score += 1
	$UI/ScoreLabel.text = "Score: " + str(score)
