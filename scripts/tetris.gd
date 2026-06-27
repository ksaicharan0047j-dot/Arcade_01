extends Node2D

const CELL_SIZE = 28
const GRID_WIDTH = 10
const GRID_HEIGHT = 20

var block_scene = preload("res://scenes/block.tscn")

const Tetromino = preload("res://scripts/tetromino.gd")

var board = []
var current_piece
var piece_pos = Vector2i()
var board_origin : Vector2
var score = 0
var game_over = false
var lines = 0
var level = 1
var game_over_selection = 0
func _ready():
	board_origin = Vector2(120,(get_viewport_rect().size.y - GRID_HEIGHT * CELL_SIZE) / 2 )
	for y in range(GRID_HEIGHT):
		board.append([])
		for x in range(GRID_WIDTH):
			board[y].append(null)
	spawn_piece()
	$PieceTimer.start()
	queue_redraw()
	update_score(0)
	update_level()
func _draw():
	var w = GRID_WIDTH * CELL_SIZE
	var h = GRID_HEIGHT * CELL_SIZE
	
	draw_rect(Rect2(board_origin,Vector2(w,h)),Color(0.08,0.08,0.08))
	for x in range(GRID_WIDTH + 1):
		draw_line(board_origin + Vector2(x * CELL_SIZE,0),board_origin + Vector2(x * CELL_SIZE,h),Color.DIM_GRAY)
	for y in range(GRID_HEIGHT + 1):
		draw_line(board_origin + Vector2(0,y * CELL_SIZE),board_origin + Vector2(w,y * CELL_SIZE),Color.DIM_GRAY)
func spawn_piece():
	var shapes = ["I","O","T","S","Z","J","L"]
	current_piece = Tetromino.new(shapes.pick_random())
	piece_pos = Vector2i(3,0)
	if !can_move(Vector2i.ZERO):
		game_over = true
		$PieceTimer.stop()
		$CanvasLayer/GameOverPanel.visible = true
		$CanvasLayer/GameOverPanel/FinalScoreLabel.text = "Score: " + str(score)
		game_over_selection = 0
		update_gameover_selector()
		return
	redraw_piece()
func redraw_piece():
	for child in $Grid.get_children():
		if child.is_in_group("active"):
			child.queue_free()
	for cell in current_piece.cells:
		var block = block_scene.instantiate()
		block.add_to_group("active")
		block.position = board_origin + Vector2(piece_pos.x + cell.x, piece_pos.y + cell.y) * CELL_SIZE
		$Grid.add_child(block)
func can_move(dir: Vector2i) -> bool:
	for cell in current_piece.cells:
		var x = piece_pos.x + cell.x + dir.x
		var y = piece_pos.y + cell.y + dir.y
		if x < 0:
			return false
		if x >= GRID_WIDTH:
			return false
		if y >= GRID_HEIGHT:
			return false
		if y >= 0 and board[y][x] != null:
			return false
	return true
func lock_piece():
	for child in $Grid.get_children():
		if child.is_in_group("active"):
			child.remove_from_group("active")
			var grid_x = int((child.position.x - board_origin.x) / CELL_SIZE)
			var grid_y = int((child.position.y - board_origin.y) / CELL_SIZE)
			board[grid_y][grid_x] = child
	clear_lines()
func clear_lines():
	var cleared = 0
	for y in range(GRID_HEIGHT - 1, -1, -1):
		var full = true
		for x in range(GRID_WIDTH):
			if board[y][x] == null:
				full = false
				break
		if full:
			remove_line(y)
			cleared += 1
	if cleared > 0:
		lines += cleared
		var new_level = lines / 10 + 1
		if new_level > level:
			level = new_level
			$PieceTimer.wait_time = max(0.08,$PieceTimer.wait_time - 0.05)
			update_level()
			match cleared:
				1:
					update_score(100)
				2:
					update_score(300)
				3:
					update_score(500)
				4:
					update_score(800)
func remove_line(row):
	for x in range(GRID_WIDTH):
		board[row][x].queue_free()
		board[row][x] = null
	for y in range(row - 1,-1,-1):
		for x in range(GRID_WIDTH):
			board[y + 1][x] = board[y][x]
			if board[y + 1][x]:
				board[y + 1][x].position.y += CELL_SIZE
	for x in range(GRID_WIDTH):
		board[0][x] = null
func _on_piece_timer_timeout():
	if can_move(Vector2i(0,1)):
		piece_pos.y += 1
	else:
		lock_piece()
		spawn_piece()
	redraw_piece()
func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		if can_move(Vector2i(-1,0)):
			piece_pos.x -= 1
		redraw_piece()
	if event.is_action_pressed("ui_right"):
		if can_move(Vector2i(1,0)):
			piece_pos.x += 1
		redraw_piece()
	if event.is_action_pressed("ui_down"):
		if can_move(Vector2i(0,1)):
			piece_pos.y += 1
		redraw_piece()
	if event.is_action_pressed("ui_up"):
		var old_cells = current_piece.cells.duplicate(true)
		current_piece.rotate()
		if !can_move(Vector2i.ZERO):
			piece_pos.x += 1
			if !can_move(Vector2i.ZERO):
				piece_pos.x -= 2
				if !can_move(Vector2i.ZERO):
					piece_pos.x += 1
					current_piece.cells = old_cells
	if game_over:
		if event.is_action_pressed("ui_up"):
			game_over_selection = 0
			update_gameover_selector()
		if event.is_action_pressed("ui_down"):
			game_over_selection = 1
			update_gameover_selector()
		if event.is_action_pressed("ui_accept"):
			if game_over_selection == 0:
				get_tree().reload_current_scene()
			else:
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func update_score(points):
	score += points
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)
func update_level():
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
	$CanvasLayer/LinesLabel.text = "Lines: " + str(lines)
func update_gameover_selector():
	if game_over_selection == 0:
		$CanvasLayer/GameOverPanel/RestartLabel.text = "> Restart"
		$CanvasLayer/GameOverPanel/MainMenuLabel.text = " Main Menu"
	else:
		$CanvasLayer/GameOverPanel/RestartLabel.text = " Restart"
		$CanvasLayer/GameOverPanel/MainMenuLabel.text = "> Main Menu"
