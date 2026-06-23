extends Control
func _ready():
	$VBoxContainer/GameOverLabel.text = "GAME OVER"
	$VBoxContainer/ScoreLabel.text = ("SCORE: " + str(Global.final_breakout_score))
	$VBoxContainer/HighScoreLabel.text = ("BEST: " + str(Global.best_breakout_score))
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/breakout_game.tscn")
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
