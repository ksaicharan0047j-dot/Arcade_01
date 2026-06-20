extends Control

@onready var result_label = $ResultLabel
@onready var time_label = $TimeLabel
@onready var best_time_label = $BestTimeLabel
var blink_timer = 0.0

func _ready():

	if Global.player_won:

		result_label.text = "YOU WIN"

		if Global.final_time < Global.best_time:

			Global.best_time =Global.final_time

	else:

		result_label.text = "YOU LOSE"

	time_label.text = (
		"TIME: " +
		str(snapped(
			Global.final_time,
			0.01
		))
	)

	best_time_label.text = (
		"BEST: " +
		str(snapped(
			Global.best_time,
			0.01
		))
	)

func _process(delta):

	if Input.is_key_pressed(KEY_R):

		get_tree().change_scene_to_file(
			"res://scenes/tank_duel.tscn"
		)

	if Input.is_key_pressed(KEY_ESCAPE):

		get_tree().change_scene_to_file(
			"res://scenes/main_menu.tscn"
		)
		
	blink_timer += delta
	
	if int(blink_timer * 2) % 2 == 0:
		$ResultLabel.visible = true
	else:
		$ResultLabel.visible = false
