class_name GridController extends Node

var _score_controller: ScoreController
var _game_state_holder: GameStateHolder
var _shape_library: ShapeLibrary
var _sfx: SFXPlayer

var state: GameState:
	get: return GameStateHolder.game_state
	
func bind_services(score_controller: ScoreController,\
		game_state_holder: GameStateHolder,\
		shape_library: ShapeLibrary,
		sfx: SFXPlayer) -> void:
	_score_controller = score_controller
	_game_state_holder = game_state_holder
	_shape_library = shape_library
	_sfx = sfx

func move_active_blocks(direction: Vector2i) -> void:
	if can_move_active_blocks(direction):
		state.current_active_shape.offset += direction
		state.last_slide_time = state.active_time

func can_move_active_blocks(direction: Vector2i) -> bool:
	if state.active_time < state.last_slide_time + GameConstants.SLIDE_TIME:
		return false
	if not state.current_active_shape or state.current_active_shape\
		.get_tiles_with_rot_and_offset(state.current_active_shape.rotation, state.current_active_shape.offset + direction)\
		.any(is_position_illegal):
		return false
	return true

func rotate_active_blocks() -> void:
	if can_rotate_active_blocks():
		state.current_active_shape.rotate()

func can_rotate_active_blocks() -> bool:
	# TODO: this is not stopping us from rotating!
	if state.current_active_shape\
		.get_tiles_with_rot_and_offset(state.current_active_shape.rotation + 1, state.current_active_shape.offset)\
		.any(is_position_illegal):
		return false
	return true
	
func is_position_illegal(tile: Vector2i) -> bool:
	return tile.x >= GameConstants.WIDTH \
	|| tile.x < 0 \
	|| tile.y >= GameConstants.HEIGHT \
	|| tile.y < 0 \
	|| state.grid[Grid.v2i_to_index(tile)] > 0

func is_touching_ground(tile: Vector2i) -> bool:
	# return true if on the bottom row
	if tile.y >= GameConstants.HEIGHT - 1:
		return true
	var tile_index: int = Grid.v2i_to_index(tile)
	var below_index: int = Grid.get_address_below_index(tile_index)
	# return true if there's a tile under it
	return state.grid[below_index] != 0
	
func is_current_shape_touching_ground() -> bool:
	if not state.current_active_shape:
		return false
	return state.current_active_shape.tiles.any(is_touching_ground)

func get_drop_preview_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = state.current_active_shape.tiles
	var drop_y: int = GameConstants.HEIGHT - 1

	# find the value of y when the shape would first be grounded
	for y: int in range(0, GameConstants.HEIGHT):
		for tile: Vector2i in tiles:
			if is_touching_ground(tile + Vector2i(0, y)):
				drop_y = y
				break
		if drop_y < GameConstants.HEIGHT - 1:
			break
			
		
	var untyped: Array = tiles.map(func(t: Vector2i) -> Vector2i: return t + Vector2i(0, drop_y))
	var typed_array: Array[Vector2i]
	typed_array.assign(untyped)
	return typed_array

func convert_active_tiles_to_grid() -> void:
	for tile: Vector2i in state.current_active_shape.tiles:
		var tile_index: int = Grid.v2i_to_index(tile)
		state.grid[tile_index] = state.current_active_shape.resource.color
	state.current_active_shape = null

func generate_new_active_tile_shape() -> void:
	state.current_active_shape = state.next_active_shape
	@warning_ignore("unsafe_method_access")
	@warning_ignore("unsafe_cast")
	var shape: ShapeResource = _shape_library.get_random_shape() as ShapeResource
	if shape:
		state.next_active_shape = Shape.new(Vector2i(5, 0), shape)
		Events.on_new_next_shape.emit()

func can_clear_row(row: int) -> bool:
	var start_index: int = row * GameConstants.WIDTH
	return range(0, GameConstants.WIDTH).all(func(i: int) -> bool: return state.grid[i + start_index] > 0)

func check_and_clear_rows() -> void:
	# this should go from top down since the row clears can cause things to fall!
	for i: int in range(0, GameConstants.HEIGHT):
		if can_clear_row(i):
			@warning_ignore("unsafe_method_access")
			_sfx.request_sound(SFXPlayer.Key.CLEAR)
			clear_row(i)

func clear_row(row: int) -> void:
	var old_row: Array[int] = state.grid.slice(row * GameConstants.WIDTH, (row + 1) * GameConstants.WIDTH + 1)
	Events.on_row_clear.emit(row, old_row)

	# make all above rows fall by slicing the values in the removed row out, 
	# then adding in a blank row at top
	var fresh_row: Array[int] = []
	fresh_row.resize(GameConstants.WIDTH)
	fresh_row.fill(0)
	var new_grid: Array[int] = fresh_row + state.grid.slice(0, row * GameConstants.WIDTH) + state.grid.slice((row + 1) * GameConstants.WIDTH, GameConstants.TILE_COUNT + 1)
	state.grid = []
	for value: int in new_grid:
		state.grid.append(value)
	
	# add score
	_score_controller.add_score(100)
