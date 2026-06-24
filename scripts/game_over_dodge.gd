extends Control
func _ready():
	$VBoxContainer/ScoreLabel.text = "SCORE: " + str(GameData.dodge_final)
	$VBoxContainer/HighScoreLabel.text = "BEST: " + str(GameData.dodge_high)
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dodge_arena.tscn")
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
