extends CharacterBody2D

var speed = 400.0
var bullet_scene = preload("res://scenes/bullet.tscn")
var player
var last_player_x = 0.0
var player_velocity = 0.0

func _physics_process(delta):
	player_velocity = player.position.x - last_player_x
	last_player_x = player.position.x
	var future_x = player.position.x + player_velocity * 10
	var distance = future_x - position.x
	if abs(distance) > 15:
		if distance > 0:
			position.x += speed * delta
		else:
			position.x -= speed * delta
	position.x = clamp(position.x, 100, 1050)

func _draw():
	draw_rect(Rect2(-25,-15,50,30),Color.WHITE)
	draw_rect(Rect2(-15,-25,30,20),Color.WHITE)
	draw_rect(Rect2(-4,-45,8,25),Color.WHITE)

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.owner_type = "enemy"
	bullet.direction = 1
	bullet.global_position = (global_position + Vector2.UP.rotated(rotation) * 45)
	get_parent().get_node("BulletContainer").add_child(bullet)

func enemy_loop():
	while true:
		await get_tree().create_timer(0.4).timeout
		var distance = player.position.x - position.x
		if abs(distance) < randf_range(20,60):
			shoot()

func _ready():
	queue_redraw()
	player = get_parent().get_node("PlayerTank")
	enemy_loop()
