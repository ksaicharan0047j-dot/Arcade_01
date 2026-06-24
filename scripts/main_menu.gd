extends Control
@onready var selector = $Selector
@onready var page1 = $VBoxContainer_Page1
@onready var page2 = $VBoxContainer_Page2
var current_page = 1
var selected = 0
var blink_timer := 0.0
var labels = []
func _ready():
	ScreenManager.set_landscape()
	show_page_1()
func show_page_1():
	current_page = 1
	page1.visible = true
	page2.visible = false
	labels = [
		page1.get_node("AsteroidvoidLabel"),
		page1.get_node("TankDuelLabel"),
		page1.get_node("PulseSurvivalLabel"),
		page1.get_node("SnakeLabel"),
		page1.get_node("PingPongLabel"),
		page1.get_node("BreakoutLabel"),
		page1.get_node("NextPageLabel")
	]
	selected = 0
	update_selector()
func show_page_2():
	current_page = 2
	page1.visible = false
	page2.visible = true
	labels = [
		page2.get_node("FlappySquareLabel"),
		page2.get_node("FroggerLabel"),
		page2.get_node("SpaceInvadersLabel"),
		page2.get_node("DodgeArenaLabel"),
		page2.get_node("BackLabel"),
		page2.get_node("QuitLabel")
	]
	selected = 0
	update_selector()
func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		selected += 1
	if event.is_action_pressed("ui_up"):
		selected -= 1
	selected = clamp(selected,0,labels.size() - 1)
	update_selector()
	if event.is_action_pressed("ui_accept"):
		launch_game()
func update_selector():
	selector.global_position.y = labels[selected].global_position.y
func launch_game():
	if current_page == 1:
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
				get_tree().change_scene_to_file("res://scenes/pong_game.tscn")
			5:
				get_tree().change_scene_to_file("res://scenes/breakout_game.tscn")
			6:
				show_page_2()
	else:
		match selected:
			0:
				get_tree().change_scene_to_file("res://scenes/flappy_square.tscn")
			1:
				pass #Frogger 
			2:
				pass # space invaders
			3:
				pass #pinball
			4:
				show_page_1()
			5:
				get_tree().quit()
func _process(delta):
	blink_timer += delta
	selector.visible = int(blink_timer) % 2 == 0
