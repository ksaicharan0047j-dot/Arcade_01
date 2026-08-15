extends CharacterBody2D
const SPEED := 80.0
enum State {
	WAITING,
	MOVING
}

var state: State = State.WAITING
var current_marker: TurnMarker
var target_marker: TurnMarker
var direction := Vector2.ZERO
var released := false
@export var ghost_color_row := 0
@onready var sprite: Sprite2D = $Sprite2D
@onready var markers = $"../..Maze/Markers"

func _ready():
	setup_sprite()

func setup_sprite():
	sprite.texture = preload("res://sprites/PacManAssets-Ghosts.png")
	sprite.hframes = 8
	sprite.vframes = 22
	sprite.frame = ghost_color_row * 8
	sprite.scale = Vector2(2.0,2.0)

func spawn_at_ghost_box():
	var spawn_marker = markers.get_node_or_null("ChostSpawn") as TurnMarker
	if spawn_marker == null:
		print("ERROR: GhostSpawn marker not found")
		return
	current_marker = spawn_marker
	target_marker = null
	direction = Vector2.ZERO
	state = State.WAITING
	released = false
	global_position = spawn_marker.global_position
	visible = true
	print("name, spawned at ghost spawn")

func release_ghost():
	if released:
		return
	released = true
	var next_marker = current_marker.get_next(Vector2.DOWN)
	if next_marker == null:
		print("ERROR: ghost spawn has no up connection for", name)
