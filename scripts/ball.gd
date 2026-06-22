extends CharacterBody2D

var ball_velocity = Vector2(700, 350)

func _physics_process(delta):

	position += ball_velocity * delta

	# Top / Bottom wall bounce
	if position.y <= 10:
		position.y = 10
		ball_velocity.y *= -1

	if position.y >= 638:
		position.y = 638
		ball_velocity.y *= -1

	var player = get_parent().get_node("PlayerPaddle")
	var ai = get_parent().get_node("AIPaddle")

	# Player paddle collision
	if abs(position.x - player.position.x) < 20 and abs(position.y - player.position.y) < 60:

		if ball_velocity.x < 0:
			ball_velocity.x *= -1

	# AI paddle collision
	if abs(position.x - ai.position.x) < 20 and abs(position.y - ai.position.y) < 60:

		if ball_velocity.x > 0:
			ball_velocity.x *= -1

	# Left goal (AI scores)
	if position.x < -20:
		get_parent().player_scored_ai()

	# Right goal (Player scores)
	if position.x > 1172:
		get_parent().player_scored_player()

func _draw():
	draw_rect(Rect2(-10, -10, 20, 20),Color.WHITE)

func _ready():
	queue_redraw()
