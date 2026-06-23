extends Node2D
var score = 0
var lives = 3
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var lives_label = $CanvasLayer/LivesLabel
func _process(_delta):
	score_label.text = "SCORE: " + str(score)
	lives_label.text = "LIVES: " + str(lives)
