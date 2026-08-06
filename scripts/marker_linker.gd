extends Node2D

const SAME_LINE_TOLERANCE := 8.0
func _ready():
	var markers = []
	for child in get_parent().get_children():
		if child is TurnMarker:
			markers.append(child)
			
	for marker in markers:
		marker.up = find_up(marker, markers)
		marker.down = find_down(marker, markers)
		marker.left = find_left(marker, markers)
		marker.right = find_right(marker, markers)
	print("Markers Linked successfully")
	queue_free()

func find_up(marker, markers):
	var best = null
	var best_distance = INF
	for m in markers:
		if m == marker:
			continue
		if abs(m.global_position.x - marker.global_position.x) > SAME_LINE_TOLERANCE:
			continue
		var d = marker.global_position.distance_to(m.global_position)
		if d < best_distance:
			best_distance= d
			best = m
	return best
func find_down(marker, markers):
	var best = null
	var best_distance = INF
	for m in markers:
		if m == marker:
			continue
		if abs(m.global_position.x - marker.global_position.x) > SAME_LINE_TOLERANCE:
			continue
		if m.global_position.y <= marker.global_position.y:
			continue
		var d = marker.global_position.distance_to(m.global_position)
		if d < best_distance:
			best_distance = d
			best = m
	return best

func find_left(marker, markers):
	var best = null
	var best_distance = INF
	for m in markers:
		if m == marker:
			continue
		if abs(m.global_position.y - marker.global_position.y) > SAME_LINE_TOLERANCE:
			continue
		if m.global_position.x >= marker.global_position.x:
			continue
		var d = marker.global_position.distance_to(m.global_position)
		if d < best_distance:
			best_distance = d
			best = m
	return best

func find_right(marker, markers):
	var best = null
	var best_distance = INF
	for m in markers:
		if m == marker:
			continue
		if abs(m.global_position.y - marker.global_position.y) > SAME_LINE_TOLERANCE:
			continue
		if m.global_position.x <= marker.global_position.x:
			continue
		var d = marker.global_position.distance_to(m.global_position)
		if d < best_distance:
			best_distance = d
			best = m
	return best
