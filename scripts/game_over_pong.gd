extends Control

func _ready():

	$VBoxContainer/GameOverLabel.text = (
		Global.pong_winner + " WINS"
	)

	$VBoxContainer/ScoreLabel.text = (
		str(Global.pong_player_score)
		+ " - " +
		str(Global.pong_ai_score)
	)

func _on_restart_button_pressed() -> void:

	get_tree().change_scene_to_file(
		"res://scenes/pong_game.tscn"
	)

func _on_menu_button_pressed() -> void:

	get_tree().change_scene_to_file(
		"res://scenes/main_menu.tscn"
	)
