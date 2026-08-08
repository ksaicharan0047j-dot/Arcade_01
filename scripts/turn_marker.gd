extends Marker2D
class_name TurnMarker

@export var up: TurnMarker
@export var down: TurnMarker
@export var left: TurnMarker
@export var right: TurnMarker

@export var marker_name := ""

func get_next(dir: Vector2) -> TurnMarker:
	if dir == Vector2.UP:
		return up
	elif dir == Vector2.DOWN:
		return down
	elif dir == Vector2.LEFT:
		return left
	elif dir == Vector2.RIGHT:
		return right
	return null
