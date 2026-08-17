extends Node2D

const RELEASE_DELAY := 3.0

@onready var blinky = $Blinky
@onready var pinky = $Pinky
@onready var inky = $Inky
@onready var clyde = $Clyde

var ghosts: Array = []
var release_index := 0
var release_timer := 0.0


func _ready():
	ghosts = [
		blinky,
		pinky,
		inky,
		clyde
	]

	for ghost in ghosts:
		if ghost.has_method("setup_ghost"):
			ghost.setup_ghost()

	release_timer = 1.0


func _process(delta):
	if release_index >= ghosts.size():
		return

	release_timer -= delta

	if release_timer <= 0.0:
		release_next_ghost()
		release_timer = RELEASE_DELAY


func release_next_ghost():
	var ghost = ghosts[release_index]

	if ghost != null and ghost.has_method("release_ghost"):
		ghost.release_ghost()
		print(
			"Ghost released: ",
			ghost.name
		)

	release_index += 1
