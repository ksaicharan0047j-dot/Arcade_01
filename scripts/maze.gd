extends Node2D
const SAME_LINE_TOLERANCE := 0.0
@onready var markers = $Markers
@onready var left_tunnel: Marker2D = $WrapTunnels/LeftTunnel
@onready var right_tunnel: Marker2D = $WrapTunnels/RightTunnel

func _ready():
	link_markers()
	print("Marker graph built")

func link_markers():
	var all_markers : Array[TurnMarker] = []
	for child in markers.get_children():
		if child is TurnMarker:
			all_markers.append(child)
	for marker in all_markers:
		marker.up = nearest(marker, all_markers, Vector2.UP)
		marker.down = nearest(marker, all_markers, Vector2.DOWN)
		marker.left = nearest(marker, all_markers, Vector2.LEFT)
		marker.right = nearest(marker, all_markers, Vector2.RIGHT)

func nearest(origin:TurnMarker, list:Array[TurnMarker], dir:Vector2) -> TurnMarker:
	var best : TurnMarker = null
	var best_dist := INF
	for m in list:
		if m == origin:
			continue
		match dir:
			Vector2.UP:
				if abs(m.global_position.x-origin.global_position.x) > SAME_LINE_TOLERANCE:
					continue
				if m.global_position.y >= origin.global_position.y:
					continue
			Vector2.DOWN:
				if abs(m.global_position.x-origin.global_position.x) > SAME_LINE_TOLERANCE:
					continue
				if m.global_position.y<=origin.global_position.y:
					continue
			Vector2.LEFT:
				if abs(m.global_position.y-origin.global_position.y)>SAME_LINE_TOLERANCE:
					continue
				if m.global_position.x >= origin.global_position.x:
					continue
			Vector2.RIGHT:
				if abs(m.global_position.y-origin.global_position.y)>SAME_LINE_TOLERANCE:
					continue
				if m.global_position.x<= origin.global_position.x:
					continue
		var d = origin.global_position.distance_to(m.global_position)
		if d < best_dist:
			best_dist = d
			best = m
	return best
func _on_left_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		body.global_position = right_tunnel.global_position


func _on_right_trigger_body_entered(body):
	if body.name == "PacmanPlayer":
		body.global_position = left_tunnel.global_position
