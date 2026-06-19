extends CharacterBody2D

const SPEED := 500.0
const SCREEN_WIDTH := 1152.0
var lanes = [350.0, 450.0, 550.0, 650.0, 750.0]
var current_lane = 2
var target_x = 550.0

func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		current_lane -= 1
	if event.is_action_pressed("ui_right"):
		current_lane += 1
	current_lane = clamp(current_lane, 0, 4)
	target_x = lanes[current_lane]
	
func _draw(): 

	draw_polygon([Vector2(0,-25),Vector2(-15,15),Vector2(0,5),Vector2(15,15)],[Color.WHITE])
	
func _ready():
	position.x = lanes[current_lane]
	target_x = position.x
	queue_redraw()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	game_over()
	
func _physics_process(delta):
	position.x = lerp(position.x, target_x, 12.0 * delta)

func game_over():
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.2).timeout
	Engine.time_scale = 0.25
	GameData.final_score = int(get_parent().score)
	if GameData.final_score > GameData.high_score:
		GameData.high_score = GameData.final_score
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
