extends Area2D

var speed = 700.0
var direction = -1
var owner_type = ""

func _process(delta):
	position.y += speed * direction * delta
	if position.y < -50:
		queue_free()
	if position.y > 700:
		queue_free()
func _draw():
	draw_rect(Rect2(-3, -6,6,12),Color.WHITE)
func _ready():
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		queue_free()
