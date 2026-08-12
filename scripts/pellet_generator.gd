@tool
extends Node2D

const PELLET_SPACING := 30.0

@export var pellet_scene: PackedScene

@export_category("Generator")

@export var generate_pellets_now := false:
	set(value):
		generate_pellets_now = value

		if value and Engine.is_editor_hint():
			call_deferred("generate_pellets")

@export var clear_pellets_now := false:
	set(value):
		clear_pellets_now = value

		if value and Engine.is_editor_hint():
			call_deferred("clear_pellets")


func generate_pellets():

	if pellet_scene == null:
		print("ERROR: Assign pellet.tscn first.")
		generate_pellets_now = false
		return

	var maze = get_parent().get_node_or_null("Maze")

	if maze == null:
		print("ERROR: Could not find Maze.")
		generate_pellets_now = false
		return

	var markers_node = maze.get_node_or_null("Markers")

	if markers_node == null:
		print("ERROR: Could not find Maze/Markers.")
		generate_pellets_now = false
		return

	# Clear old generated pellets first
	clear_pellets()

	var markers: Array[TurnMarker] = []

	for child in markers_node.get_children():

		if child is TurnMarker:
			markers.append(child)

	var generated := 0

	for marker in markers:

		# RIGHT
		if marker.right != null:

			generated += create_pellets_between(
				marker,
				marker.right
			)

		# DOWN
		if marker.down != null:

			generated += create_pellets_between(
				marker,
				marker.down
			)

	print("================================")
	print("PELLETS GENERATED: ", generated)
	print("================================")

	generate_pellets_now = false


func create_pellets_between(
	start_marker: TurnMarker,
	end_marker: TurnMarker
) -> int:

	var start := start_marker.global_position
	var end := end_marker.global_position

	var distance := start.distance_to(end)

	if distance <= PELLET_SPACING:
		return 0

	var count := int(distance / PELLET_SPACING)

	var created := 0

	for i in range(1, count):

		var pellet_position := start.lerp(
			end,
			float(i) / float(count)
		)

		var pellet = pellet_scene.instantiate()

		# Put generated pellets inside the Pellets node
		var pellets_node = get_parent().get_node_or_null("Pellets")

		if pellets_node == null:
			print("ERROR: Could not find Pellets node.")
			pellet.queue_free()
			return created

		pellets_node.add_child(pellet)

		pellet.global_position = pellet_position

		# Save generated pellet into the scene
		if Engine.is_editor_hint():
			pellet.owner = get_tree().edited_scene_root

		created += 1

	return created


func clear_pellets():

	var pellets_node = get_parent().get_node_or_null("Pellets")

	if pellets_node == null:
		print("ERROR: Could not find Pellets node.")
		clear_pellets_now = false
		return

	for child in pellets_node.get_children():

		if child is Area2D:

			if Engine.is_editor_hint():
				child.free()
			else:
				child.queue_free()

	clear_pellets_now = false

	print("Generated pellets cleared.")
