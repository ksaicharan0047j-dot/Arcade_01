extends Node2D
const CELL_SIZE = 28
const GRID_WIDTH = 10
const GRID_HEIGHT = 20
var tetromino_scene = preload("res://scenes/tetromino.tscn")
var board_origin : Vector2
var current_piece : Node2D
var piece_grid_pos := Vector2i()
var piece_locked = false
var board = []
func _ready():
	var board_width = GRID_WIDTH * CELL_SIZE
	var board_height = GRID_HEIGHT * CELL_SIZE
	board_origin = Vector2(120,(get_viewport_rect().size.y - board_height) / 2)
	queue_redraw()
	board.resize(GRID_HEIGHT)
	spawn_piece()
	$PieceTimer.start()
	for y in range(GRID_HEIGHT):
		board[y] = []
		board[y].resize(GRID_WIDTH)
		for x in range(GRID_WIDTH):
			board[y][x] = null
func _draw():
	var board_width = GRID_WIDTH * CELL_SIZE
	var board_height = GRID_HEIGHT * CELL_SIZE
	draw_rect(Rect2(board_origin,Vector2(board_width,board_height)),Color(0.08,0.08,0.08))
	for x in range(GRID_WIDTH + 1):
		draw_line(board_origin + Vector2(x * CELL_SIZE,0),board_origin + Vector2(x * CELL_SIZE,board_height),Color.DIM_GRAY)
	for y in range(GRID_HEIGHT + 1):
		draw_line(board_origin + Vector2(0,y * CELL_SIZE),board_origin + Vector2(board_width,y * CELL_SIZE),Color.DIM_GRAY)
func spawn_piece():
	piece_locked = false
	if current_piece:
		current_piece.queue_free()
	current_piece = tetromino_scene.instantiate()
	piece_grid_pos =Vector2i(3,0)
	$ActivePiece.add_child(current_piece)
	update_piece_position()
func update_piece_position():
	current_piece.position = board_origin + Vector2(piece_grid_pos.x,piece_grid_pos.y) * CELL_SIZE
func _on_piece_timer_timeout():
	piece_grid_pos.y += 1
	if piece_grid_pos.y > GRID_HEIGHT - 1:
		piece_grid_pos.y = GRID_HEIGHT - 1
		piece_locked = true
		lock_piece()
		spawn_piece()
	update_piece_position()
func _unhandled_input(event):
	if piece_locked:
		return
	if event.is_action_pressed("ui_left"):
		piece_grid_pos.x = max(0,piece_grid_pos.x - 1)
	if event.is_action_pressed("ui_right"):
		piece_grid_pos.x = min(GRID_WIDTH - 4,piece_grid_pos.x + 1)
	if event.is_action_pressed("ui_down"):
		piece_grid_pos.y = min(GRID_HEIGHT - 1,piece_grid_pos.y + 1)
	update_piece_position()
func lock_piece():
	var block_scene = preload("res://scenes/block.tscn")
	for block in current_piece.get_children():
		var grid_x = piece_grid_pos.x + int(block.position.x / CELL_SIZE)
		var grid_y = piece_grid_pos.y + int(block.position.y / CELL_SIZE)
		board[grid_y][grid_x] = true
		var placed_block = block_scene.instantiate()
		placed_block.position = board_origin + Vector2(grid_x,grid_y) * CELL_SIZE
		$Grid.add_child(placed_block)
	current_piece.queue_free()
	current_piece = null
