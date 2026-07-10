extends Node2D

enum IntroState{
	CHASE,
	REVERSE,
	WAIT
}
const PACMAN_SPEED := 150.0
const GHOST_SPEED := 150.0
@onready var pacman = $PacmanPlayer
@onready var ghosts = $Ghosts
@onready var title = $Title
@onready var press_start = $PressStart
@onready var main_menu = $MainMenuLabel
var state := IntroState.CHASE
var blink_timer := 0.0
var look_dir := Vector2.RIGHT

func _ready():
	title.visible = false
	press_start.visible = false
	main_menu.visible = false
	reset_intro()
	pacman.get_node("AnimatedSprite2D").play("move")
	for ghost in ghosts.get_children():
		ghost.look_dir = Vector2.RIGHT
func reset_intro():
	pacman.position = Vector2(-120,320)
	var positions = [
		Vector2(-170,320),
		Vector2(-210,320),
		Vector2(-250,320),
		Vector2(-290,320)
	]
	for i in range(ghosts.get_child_count()):
		ghosts.get_child(i).position = positions[i]

func _process(delta):
	match state:
		IntroState.CHASE:
			pacman.position.x += PACMAN_SPEED * delta
			for ghost in ghosts.get_children():
				ghost.position.x == GHOST_SPEED * delta
			if pacman.position.x > 1450:
				state = IntroState.REVERSE
				pacman.position = Vector2(1450,320)
				pacman.get_node("AnimatedSprite2D").flip_h = true
				var positions = [
					Vector2(1500,320),
					Vector2(1540,320),
					Vector2(1580,320),
					Vector2(1620,320)
				]
				for i in range(ghosts.get_child_count()):
					ghosts.get_child(i).position = positions[i]
					ghosts.get_child(i).look_dir = Vector2.LEFT
		IntroState.REVERSE:
			pacman.position.x -= PACMAN_SPEED * delta
			for ghost in ghosts.get_children():
				ghost.position.x -= GHOST_SPEED * delta
			if ghosts.get_node("blinky").position.x < -350:
				title.visible = true
				press_start.visible = true
				main_menu.visible = true
				pacman.scale.x = 1
				reset_intro()
				for ghost in ghosts.get_children():
					ghost.look_dir = Vector2.RIGHT
				state = IntroState.WAIT
		IntroState.WAIT:
			blink_timer += delta
			if blink_timer >= 0.5:
				blink_timer = 0
				press_start.visible = !press_start.visible

func _input(event):
	if state != IntroState.WAIT:
		return
	if event.ia_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/pacman_game.tscn")
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
