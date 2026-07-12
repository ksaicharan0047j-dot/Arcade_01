extends Node2D

@onready var left_tunnel: Marker2D = $WrapTunnels/LeftTunnel
@onready var right_tunnel: Marker2D = $WrapTunnels/RightTunnel

func _ready():
	pass

func _on_left_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		body.global_position = right_tunnel.global_position

func _on_right_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		body.global_position = left_tunnel.global_position
