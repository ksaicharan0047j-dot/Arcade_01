extends Control
func _ready():
	$VBoxContainer/GameOverLabel.text = "GAME OVER"
	$VBoxContainer/ScoreLabel.text = ("SCORE: " + str(Global.final_flappy_score))
	$VBoxContainer/HighScoreLabel.text = ("BEST: " + str(Global.best_flappy_score))
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/flappy_square.tscn")
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
