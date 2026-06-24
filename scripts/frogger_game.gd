extends Node2D
const LANE_HEIGHT = 40
static var current_score = 0
@onready var frog = $Frog
@onready var lanes = $Lanes
@onready var lane_manager = $LaneManager
var score = 0
func frog_moved_up():
	if frog.position.y < 250:
		scroll_world()
func scroll_world():
	score += 1
	current_score = score
	frog.position.y += LANE_HEIGHT
	for lane in lanes.get_children():
		lane.position.y += LANE_HEIGHT
	var lowest_lane = null
	for lane in lanes.get_children():
		if lowest_lane == null:
			lowest_lane = lane
		elif lane.position.y > lowest_lane.position.y:
			lowest_lane = lane
	if lowest_lane:
		lowest_lane.queue_free()
	lane_manager.spawn_top_lane(score)
	print("Score:",score)
