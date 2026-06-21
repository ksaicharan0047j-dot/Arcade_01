extends Control

func _ready():

	$VBoxContainer/ScoreLabel.text = \
		"Score: " + str(GameData.final_score)

	$VBoxContainer/HighScoreLabel.text = \
		"Best: " + str(GameData.high_score)
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/pulse_survival.tscn")
	
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
