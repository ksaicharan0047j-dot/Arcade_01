extends Node2D

var radius = 0.0
var growth_speed = 200.0
var gaps = []
var dead = false
var survival_time = 0.0

func _ready():
	for i in range(3):
		gaps.append(randf() * TAU)

func _process(delta):
	radius += growth_speed * delta

	queue_redraw()

	var player = get_tree().current_scene.get_node("Player")
	check_player(player)

	if radius > 800:
		queue_free()

func _draw():
	draw_arc(
		Vector2.ZERO,
		radius,
		0,
		TAU,
		120,
		Color.WHITE,
		4
	)

	for gap in gaps:
		draw_arc(
			Vector2.ZERO,
			radius,
			gap,
			gap + 0.8,
			20,
			Color.BLACK,
			8
		)

func check_player(player):

	var player_vector = player.global_position - global_position
	var player_distance = player_vector.length()

	if abs(player_distance - radius) < 10:

		var player_angle = fposmod(
			player_vector.angle(),
			TAU
		)

		var safe = false

		for gap in gaps:
			if player_angle >= gap and player_angle <= gap + 0.8:
				safe = true
				break

		if !safe:
			get_parent().get_parent().player_died()
func player_died():
	if dead:
		return
	dead = true
	game_over()
func game_over():
	Global.final_time = survival_time
	get_tree().change_sceneto_file("res://scenes/game_over_pulse.tscn")
