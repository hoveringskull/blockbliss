extends Node

var state: GameState:
	get: return GameStateHolder.game_state

func initialize() -> void:
	# set up initial conditions
	state.active_time = 0
	state.last_drop_time = 0
	state.current_active_shape = null
	state.next_active_shape = null
	state.grid.resize(GameConstants.TILE_COUNT)
	state.grid.fill(GameConstants.TILE.NONE)

func start() -> void:
	ScoreController.reset_score()
	state.status = GameState.GAME_STATUS.ACTIVE
	GridController.generate_new_active_tile_shape()
	GridController.generate_new_active_tile_shape() # Generates a second so we have one in the queue

func toggle_pause() -> void:
	if state.status == GameState.GAME_STATUS.PAUSED:
		state.status = state.last_status
	else:
		state.last_status = state.status
		state.status = GameState.GAME_STATUS.PAUSED

func update(delta: float) -> void:
	if state.status == GameState.GAME_STATUS.ACTIVE:
		state.active_time += delta
		if state.active_time - state.last_drop_time > state.total_gravity:
			# drop current dropping tiles
			state.last_drop_time = state.active_time
			if state.current_active_shape:
				if GridController.is_current_shape_touching_ground():
					@warning_ignore("unsafe_method_access")
					Sfx.request_sound(SFX.Key.IMPACT)
					GridController.convert_active_tiles_to_grid()
					GridController.check_and_clear_rows()
					update_game_state()
					GridController.generate_new_active_tile_shape()
				else:
					state.current_active_shape.offset += Vector2i(0, 1)
				
func update_game_state() -> void:
	# check if any grid tiles are in the top row and lose if so
	for i: int in range(GameConstants.WIDTH):
		if state.grid[i] != 0:
			state.status = GameState.GAME_STATUS.LOST
