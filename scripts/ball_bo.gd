extends CharacterBody2D

var ball_velocity = Vector2(250,-250)

func _physics_process(delta):

	position += ball_velocity * delta

	# LEFT WALL
	if position.x <= 10:
		position.x = 10
		ball_velocity.x = abs(ball_velocity.x)

	# RIGHT WALL
	if position.x >= 1142:
		position.x = 1142
		ball_velocity.x = -abs(ball_velocity.x)

	# TOP WALL
	if position.y <= 10:
		position.y = 10
		ball_velocity.y = abs(ball_velocity.y)

	# BALL LOST
	if position.y >= 648:
		get_tree().change_scene_to_file(
			"res://scenes/game_over_breakout.tscn"
		)

	# PADDLE COLLISION
	var paddle = get_parent().get_node("Paddle")

	if abs(position.x - paddle.position.x) < 70 \
	and abs(position.y - paddle.position.y) < 20:

		if ball_velocity.y > 0:
			ball_velocity.y = -abs(ball_velocity.y)

	# BRICK COLLISION
	for brick in get_parent().get_node("Bricks").get_children():

		if abs(position.x - brick.position.x) < 50 \
		and abs(position.y - brick.position.y) < 20:

			ball_velocity.y *= -1

			brick.hit()

			get_parent().score += 1

			break

func _draw():
	draw_circle(
		Vector2.ZERO,
		10,
		Color.WHITE
	)

func _ready():
	position = Vector2(576,500)
	queue_redraw()
