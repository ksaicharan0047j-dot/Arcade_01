extends Node
var lane_scene = preload("res://scenes/lane.tscn")
@onready var lanes = $"../Lanes"
const LANE_HEIGHT = 40
const START_LANES = 16
func _ready():
	generate_initial_lanes()
func generate_initial_lanes():
	for i in range(START_LANES):
		if i < 2:
			spawn_grass_lane(i)
		else:
			spawn_lane(i)
func spawn_lane(index):
	var lane = lane_scene.instantiate()
	var r = randf()
	if r < 0.35:
		lane.lane_type = "grass"
		lane.lane_direction = 0
	elif r < 0.675:
		lane.lane_type = "left"
		lane.lane_direction = -1
	else:
		lane.lane_type = "right"
		lane.lane_direction = 1
	lane.position.y = 648 - ((index + 1) * LANE_HEIGHT)
	lanes.add_child(lane)
func spawn_grass_lane(index):
	var lane = lane_scene.instantiate()
	lane.lane_type = "grass"
	lane.position.y = 648 - ((index + 1) * 40)
	lanes.add_child(lane)
func spawn_top_lane(score):
	var lane = lane_scene.instantiate()
	var r = randf()
	if r < 0.35:
		lane.lane_type = "grass"
	elif r < 0.675:
		lane.lane_type = "left"
	else:
		lane.lane_type = "right"
	var highest_y = 999999
	for existing_lane in lanes.get_children():
		if existing_lane.position.y < highest_y:
			highest_y = existing_lane.position.y
	lane.position.y = highest_y - 40
	lanes.add_child(lane)
	lane.world_score = score
