extends CanvasLayer

@onready var info = $Info

var wave := 1
var score := 0
func show_results():
	info.text = \
	"       GAME OVER\n\n" + \
	"Wave Reached   %d\n" % wave + \
	"Final Score    %d\n\n" % score + \
	"SPACE - Restart\n" + \
	"ECS - MainMenu"
	get_tree().paused = true

func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
