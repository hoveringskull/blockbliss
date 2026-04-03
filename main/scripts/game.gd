extends Node2D


var game_state: GameState:
	get: return GameStateHolder.game_state
	set(value): GameStateHolder.game_state = value

var has_emitted_loss: bool = false


func _ready():
	connect_listeners()


func connect_listeners():
	Events.request_quit.connect(handle_request_quit)
	Events.request_start_game.connect(handle_request_start_game)

func handle_request_quit():
	get_tree().quit()

func handle_request_start_game():
	Events.request_hide_menu.emit()
	Music.play_game_track()
	has_emitted_loss = false
	game_state = GameState.new()
	game_state.initialize()
	game_state.start()

	$renderer.initialize()
	$renderer.update()

func _process(delta: float) -> void:
	if game_state:
		if Input.is_action_just_pressed("pause"):
			game_state.toggle_pause()
		
		if game_state.status == GameState.GAME_STATUS.ACTIVE:
			# todo: allow holding down
			if Input.is_action_pressed("right"):
				game_state.move_active_blocks(Vector2i(1, 0))
			elif Input.is_action_pressed("left"):
				game_state.move_active_blocks(Vector2i(-1, 0))

			if Input.is_action_pressed("down"):
				game_state.speed_up = true
			else:
				game_state.speed_up = false

			if Input.is_action_just_pressed("up"):
				game_state.rotate_active_blocks()

			game_state.update(delta)
			$renderer.update()
		elif game_state.status == GameState.GAME_STATUS.LOST and has_emitted_loss == false:
			Events.on_game_lost.emit()
			Music.play_loss_track()
			has_emitted_loss = true
