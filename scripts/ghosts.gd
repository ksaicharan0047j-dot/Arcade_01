extends Node2D

const RELEASE_DELAY := 3.0
@onready var blinky = $Blinky
@onready var pinky = $Pinky
@onready var inky = $Inky
@onready var clyde = $Clyde

var ghosts = []
var release_index := 0
var release_timer := 0.0

func _ready():
	ghosts = [blinky, pinky, inky, clyde]
	for ghost in ghosts:
		ghost.spawn_at_ghost_box()
	release_next_ghost()

func _process(delta):
	if release_index >= ghosts.size():
		return
	release_timer -= delta
	if release_timer <= 0.0:
		release_next_ghost()

func release_next_ghost():
	if release_index >= ghosts.size():
		return
	var ghost = ghosts[release_index]
	ghost.release_ghost()
	release_index += 1
	release_timer = RELEASE_DELAY
