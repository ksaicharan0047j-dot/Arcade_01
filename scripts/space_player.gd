extends CharacterBody2D
const SPEED = 500
const FIRE_RATE = 0.2
var can_shoot = true
@onready var bullets = $"../PlayerBullets"
func _ready():
	position = Vector2(576,600)
	queue_redraw()
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
	position.x = clamp(position.x,30,1122)
	if Input.is_action_just_pressed("ui_accept") and can_shoot:
		can_shoot = false
		bullets.shoot(position + Vector2(0,-25))
		await get_tree().create_timer(FIRE_RATE).timeout
		can_shoot = true
	queue_redraw()
func _draw():
	draw_polygon([Vector2(0,-20),Vector2(18,12),Vector2(8,8),Vector2(-8,8),Vector2(-18,12)],[Color.WHITE])
	draw_rect(Rect2(-6,-5,12,8),Color.BLACK)
	draw_polygon([Vector2(-18,12),Vector2(-28,18),Vector2(-14,4)],[Color.WHITE])
	draw_polygon([Vector2(18,12),Vector2(28,18),Vector2(14,4)],[Color.WHITE])
	draw_rect(Rect2(-4,14,8,6),Color.ORANGE_RED)
