extends Control

func _ready():

	$VBoxContainer/GameOverLabel.text = "GAME OVER"

	$VBoxContainer/ScoreLabel.text = (
		"TIME: " + str(snapped(Global.final_time, 0.01))
	)

	$VBoxContainer/HighScoreLabel.text = (
		"BEST: " + str(snapped(Global.best_time, 0.01))
	)

func _on_restart_button_pressed() -> void:

	get_tree().change_scene_to_file(
		"res://scenes/pulse_survival.tscn"
	)

func _on_menu_button_pressed() -> void:

	get_tree().change_scene_to_file(
		"res://scenes/main_menu.tscn"
	)
