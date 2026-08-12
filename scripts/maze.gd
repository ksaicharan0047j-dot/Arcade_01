extends Node2D
@onready var left_tunnel: Marker2D = $WrapTunnels/LeftTunnel
@onready var right_tunnel: Marker2D = $WrapTunnels/RightTunnel
@onready var markers: Node2D = $Markers

func _ready():
	pass

func _on_left_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		var destination_marker = markers.get_node("PacmanSpawnRight") as TurnMarker
		body.wrap_through_tunnel(
			destination_marker,
			right_tunnel.global_position
		)

func _on_right_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		var destination_marker = markers.get_node("PacmanSpawnLeft") as TurnMarker
		body.wrap_through_tunnel(
			destination_marker,
			left_tunnel.global_position
		)
