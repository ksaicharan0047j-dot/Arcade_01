extends CharacterBody2D
var step_size = 40
var lives = 3
var invincible = false
const START_POS = Vector2(576,628)
func _ready():
	position = START_POS
	queue_redraw()
	var lives_label = get_parent().get_node("CanvasLayer/LivesLabel")
	lives_label.text = "Lives: " + str(lives)
func _draw():
	draw_rect(Rect2(-10,-10,20,20),Color.RED)
func _process(_delta):
	queue_redraw()
func _unhandled_input(event):
	if invincible:
		return
	if event.is_action_pressed("ui_up"):
		position.y -= step_size
		get_parent().frog_moved_up()
	if event.is_action_pressed("ui_down"):
		position.y += step_size
	if event.is_action_pressed("ui_left"):
		position.x -= step_size
	if event.is_action_pressed("ui_right"):
		position.x += step_size
func hit():
	if invincible:
		return
	invincible = true
	lives -= 1
	print("Lives:",lives)
	if lives <= 0:
		Global.final_frogger_score = get_parent().score
		if Global.final_frogger_score > Global.best_frogger_score:
			Global.best_frogger_score = Global.final_frogger_score
			call_deferred("game_over")
			return
	position = START_POS
	await get_tree().create_timer(1.0).timeout
	invincible = false
func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over_frogger.tscn")
