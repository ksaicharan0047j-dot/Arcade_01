extends CharacterBody2D
@export var speed := 350.0
var lives = 3
func _ready():
	queue_redraw()
func _physics_process(_delta):
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	move_and_slide()
func _draw():
	draw_rect(Rect2(-10, -10, 20, 20),Color.WHITE)
func take_damage():
	lives -= 1
	print("Lives:", lives)
	var lives_label = get_parent().get_node("UI/LivesLabel")
	if lives_label:
		lives_label.text = "Lives: " + str(lives)
	if lives <= 0:
		print("GAME OVER")
		GameData.dodge_final = get_parent().score
		if GameData.dodge_final > GameData.dodge_high:
			GameData.dodge_high = GameData.dodge_final
		get_tree().change_scene_to_file("res://scenes/game_over_dodge.tscn")
