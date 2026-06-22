extends Control

@onready var selector = $Selector
@onready var labels = [
	$VBoxContainer/AsteroidvoidLabel,
	$VBoxContainer/TankDuelLabel,
	$VBoxContainer/PulseSurvivalLabel,
	$VBoxContainer/SnakeLabel,
	$VBoxContainer/QuitLabel
]
var selected = 0
var blink_timer := 0.0
var menu_y = [260.0, 320.0,380.0,440.0,500.0]

func _ready():
	update_selector()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		selected += 1
	if event.is_action_pressed("ui_up"):
		selected -= 1
		
	selected = clamp(selected,0,4)
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
			get_tree().change_scene_to_file("res://scenes/tank_duel.tscn")
		2:
			get_tree().change_scene_to_file("res://scenes/pulse_survival.tscn")
		3:
			get_tree().change_scene_to_file("res://scenes/snake_game.tscn")
		4:
			get_tree().quit()
func _process(delta):
	blink_timer += delta
	
	if int(blink_timer) % 2 == 0:
		selector.visible = true
	else:
		selector.visible = false
