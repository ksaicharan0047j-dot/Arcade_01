extends Control

@onready var selector = $Selector
@onready var labels = [
	$VBoxContainer/AsteroidvoidLabel,
	$VBoxContainer/TankDuelLabel,
	$VBoxContainer/PulseSurvivalLabel,
	$VBoxContainer/QuitLabel
]
var selected = 0

var menu_y = [260.0, 320.0,380.0,440.0]

func _ready():
	update_selector()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		selected += 1
	if event.is_action_pressed("ui_up"):
		selected -= 1
		
	selected = clamp(selected,0,3)
	update_selector()
	if event.is_action_pressed("ui_accept"):
		launch_game()

func update_selector():

	var target = labels[selected]

	selector.global_position.y = target.global_position.y
	
func launch_game():
	match selected:
		0:
			get_tree().change_scene_to_file("res://scenes/asteroid_void.tscn")
		1:
			print("Tank Duel")
		2:
			print("pulse Survival")
		3:
			get_tree().quit()
