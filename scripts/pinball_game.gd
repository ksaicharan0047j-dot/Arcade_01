extends Node2D
var score = 0
var lives = 3
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var lives_label = $CanvasLayer/LivesLabel
func _process(_delta):
	score_label.text = "SCORE: " + str(score)
	lives_label.text = "LIVES: " + str(lives)


func _on_drain_body_entered(body: Node2D) -> void:
	if body.name != "Ball":
		return
	lives -= 1
	$LivesLabel.text = "LIVES: " + str(lives)
	if lives <= 0:
		get_tree().change_scene_to_file("res://scens/game_over_pinball.tscn")
	else:
		body.freeze = true
		body.position = Vector2(1080,570)
		await get_tree().create_timer(0.5).timeout
		body.freeze = false
