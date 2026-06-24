extends Area2D
var speed = 150
var target
func _ready():
	queue_redraw()
func  _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
func _draw():
	draw_circle(Vector2.ZERO,10,Color.WHITE)
func _on_body_entered(body):
	if body.name == "PlayerDodge":
		print("ENEMY HIT PLAYER")
		body.take_damage()
		call_deferred("queue_free")
