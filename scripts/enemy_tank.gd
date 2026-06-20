extends CharacterBody2D

var speed = 400.0
var bullet_scene = preload("res://scenes/bullet.tscn")
var player
var target_x = 600.0

func _physics_process(delta):
	var distance = target_x - position.x
	if abs(distance) > 10:
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
		target_x = randf_range(150,1000)
		await get_tree().create_timer(randf_range(1.0,2.5)).timeout
		var distance = abs(player.position.x - position.x)
		if distance < 80:
			if randf() < 0.7:
				shoot()

func shooting_loop():
	while true:
		await get_tree().create_timer(0.25).timeout
		var distance = abs(player.position.x - position.x)
		if distance < 60:
			if randf() < 0.4:
				shoot()

func _ready():
	queue_redraw()
	player = get_parent().get_node("PlayerTank")
	enemy_loop.call_deferred()
	shooting_loop.call_deferred()
