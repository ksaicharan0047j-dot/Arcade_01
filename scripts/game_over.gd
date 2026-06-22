extends Control

func _ready():
	$VBoxContainer/ScoreLabel.text = "SCORE: " + str(Global.final_snake_score)
	$VBoxContainer/HighScoreLabel.text = "BEST: " + str(Global.best_snake_score)

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/snake_game.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
