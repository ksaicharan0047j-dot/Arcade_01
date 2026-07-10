extends Node2D

enum IntroState {
	CHASE,
	REVERSE,
	WAIT
}

var state = IntroState.CHASE
@onready var pacman = $PacMan
@onready var ghosts = $Ghosts
@onready var title = $Title
@onready var press_start = $PressStart
@onready var main_menu = $MainMenuLabel
var blink_timer := 0.0

func _ready():
	title.visible = false
	press_start.visible = false
	main_menu.visible = false
	pacman.position = Vector2(-120,320)
	var spacing := 40
	ghosts.get_node("Blinky").position = Vector2(-170,320)
	ghosts.get_node("Pinky").position = Vector2(-210,320)
	ghosts.get_node("Inky").position = Vector2(-250,320)
	ghosts.get_node("Clyde").position = Vector2(-290,320)

func _process(delta):
	match state:
		IntroState.CHASE:
			pacman.position.x += 150 * delta
			for ghost in ghosts.get_children():
				ghost.position.x += 150 * delta
			if pacman.position.x > 1450:
				state = IntroState.REVERSE
				pacman.position = Vector2(1450,320)
				ghosts.get_node("Blinky").position = Vector2(1500,320)
				ghosts.get_node("Pinky").position = Vector2(1540,320)
				ghosts.get_node("Inky").position = Vector2(1580,320)
				ghosts.get_node("Clyde").position = Vector2(1620,320)
		IntroState.REVERSE:
			pacman.position.x -= 145 * delta
			for ghost in ghosts.get_children():
				ghost.poostion.x -= 150 * delta
			if ghosts.get_node("Clyde").position.x < -350:
				title.visible = true
				press_start.visible = true
				main_menu.visible = true
				pacman.position = Vector2(-120,320)
				ghosts.get_node("Blinky").position = Vector2(-170,320)
				ghosts.get_node("Pinky").position = Vector2(-210,320)
				ghosts.get_node("Inky").position = Vector2(-250,320)
				ghosts.get_node("Clyde").position = Vector2(-290,320)
				state = IntroState.WAIT
		IntroState.WAIT:
			blink_timer += delta
			if blink_timer > 0.5:
				blink_timer = 0
				press_start.visible = !press_start.visible

func _input(event):
	if state != IntroState.WAIT:
		return
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/pacman.tscn")
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
