extends Node2D
var brick_scene = preload("res://scenes/brick.tscn")
var score = 0
@onready var score_label = $CanvasLayer/ScoreLabel
func _ready():
	create_bricks()
func _process(_delta):
	score_label.text = "SCORE: " + str(score)
func create_bricks():
	for row in range(4):
		for col in range(10):
			var brick = brick_scene.instantiate()
			brick.position = Vector2(100 + col * 100,80 + row * 50)
			$Bricks.add_child(brick)
