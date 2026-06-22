extends Area2D

var speed := 300.0

func _process(delta):
	position.y += speed * delta

	if position.y > 700:
		queue_free()

func _draw():
	draw_polygon(
		[
			Vector2(-15, -10),
			Vector2(-5, -18),
			Vector2(10, -15),
			Vector2(18, 0),
			Vector2(12, 15),
			Vector2(-10, 18),
			Vector2(-18, 5)
		],
		[Color.WHITE]
	)

func _ready():
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "AsteroidPlayer":

		Global.final_score = int(
			get_parent().score
		)

		call_deferred("go_to_game_over")
func go_to_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
