extends CharacterBody2D

#movement
const NORAMAL_SPEED := 120.0
const POWER_SPEED := 165.0

var speed := NORAMAL_SPEED

#Power mode
var power_mode := false
const POWER_SCALE := 1.12
const POWER_COLOR:= Color(1.0,0.55,0.25)

#Shadow
const SHADOW_COLOR := Color(0.0,0.0,0.0,0.35)
const SHADOW_RADIUS_X := 17.0
const SHADOW_RADIUS_Y := 4.0

enum State {
	WAITING,
	MOVING
}

var state: State = State.WAITING
var current_marker: TurnMarker
var target_marker: TurnMarker

var direction := Vector2.ZERO
var wanted_direction := Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var markers = $"./Maze/Markers"

func _ready():
	randomize()
	sprite.play("move")
	#Random spawn
	if randi() % 2 == 0:
		current_marker = markers.get_node("PacmanSpawnLeft")
	else:
		current_marker = markers.get_node("PacmanSpawnRight")
	global_position = current_marker.global_position
	print("pacman spawned at: ", current_marker.name)
	queue_redraw()

#Shadow
func _draw():
	draw_ellipse(
		Vector2(2,7),
		Vector2(SHADOW_RADIUS_X,SHADOW_RADIUS_Y),
		SHADOW_COLOR
	)

func draw_ellipse(
	position: Vector2,
	radius: Vector2,
	color: Color
):
	var points := PackedVector2Array()
	for i in range(32):
		var angle := TAU * float(i) / 32.0
		points.append(
			position + Vector2(
				cos(angle) * radius.x,
			)
		)
