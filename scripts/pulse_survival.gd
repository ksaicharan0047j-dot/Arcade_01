extends Node2D

var pulse_scene = preload("res://scenes/pulse.tscn")
@onready var timer_label = $CanvasLayer/TimerLabel
var survival_time = 0.0
var dead = false
func _process(delta):

	survival_time += delta

	timer_label.text = (
		"TIME: " +
		str(snapped(survival_time,0.01))
	)

	if survival_time > 30:
		$SpawnTimer.wait_time = 1.0

	elif survival_time > 15:
		$SpawnTimer.wait_time = 1.5

	else:
		$SpawnTimer.wait_time = 2.0
func _on_spawn_timer_timeout():
	var pulse = pulse_scene.instantiate()
	$PulseContainer.add_child(pulse)
	pulse.position = get_viewport_rect().size / 2
func player_died():
	if dead:
		return
	dead = true
	game_over()
func game_over():
	Global.final_time = survival_time
	get_tree().change_scene_to_file("res://scenes/game_over_pulse.tscn")
