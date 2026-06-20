extends CharacterBody2D

var bullet_scene = preload("res://scenes/bullet.tscn")
var can_shoot = true
@export var controls_enabled = false

const SPEED = 400.0
func _physics_process(delta):
	if controls_enabled:
		if Input.is_key_pressed(KEY_A):
			position.x -= SPEED * delta
		if Input.is_key_pressed(KEY_D):
			position.x += SPEED * delta
		if Input.is_action_just_pressed("shoot"):
			shoot()
	position.x = clamp(position.x,50,1100)
func _draw():
	#Tracks
	draw_rect(Rect2(-25,-15,50,30),Color.WHITE)
	#Tank body
	draw_rect(Rect2(-18,-10,36,20),Color.WHITE)
	#Turrent base
	draw_circle(Vector2(0,0),8,Color.WHITE)
	#Barrel
	draw_rect(Rect2(-3,-40,6,30),Color.WHITE)
func _ready():
	queue_redraw()

func shoot():
	if !can_shoot:
		return
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.owner_type = "player"
	bullet.global_position = global_position + Vector2.UP.rotated(rotation) * 45
	get_parent().get_node("BulletContainer").add_child(bullet)
	await get_tree().create_timer(0.3).timeout
	can_shoot = true
