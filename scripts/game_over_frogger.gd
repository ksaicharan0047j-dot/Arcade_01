extends Control
func _ready():
	$VBoxContainer/GameOverLabel.text = "GAME OVER"
	$VBoxContainer/ScoreLabel.text = ("SCORE: " + str(Global.final_frogger_score))
	$VBoxContainer/HighScoreLabel.text = ("BEST: " + str(Global.best_frogger_score))
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/frogger_game.tscn")
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
