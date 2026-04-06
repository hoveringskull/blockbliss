class_name MenuContext extends Node

signal request_quit
signal request_start_game
signal request_scores

@export var overlay: MenuOverlay

@export var camera_packed: PackedScene

var _sfx: SFXPlayer
var _music: MusicPlayer
var _high_scores: HighScores
var _game_state_holder: GameStateHolder
var _camera: GameCamera

func build_services() -> void:
	_high_scores = HighScores.new()
	add_child(_high_scores)
	
	_camera = camera_packed.instantiate()
	add_child(_camera)

func bind_services(sfx: SFXPlayer, music: MusicPlayer, gsh: GameStateHolder) -> void:
	_sfx = sfx
	_music = music
	_game_state_holder = gsh

func setup() -> void:
	overlay.initialize(_music, _sfx, _high_scores, _game_state_holder)		
	_camera.initialize(null)

	
	if _game_state_holder.game_state and  _game_state_holder.game_state.status == GameState.GAME_STATUS.LOST:
		_music.play_loss_track()
	else:
		_music.play_menu_track()

func connect_signals() -> void:
	overlay.main_menu.request_start_game.connect(request_start_game.emit)
	overlay.main_menu.request_quit.connect(request_quit.emit)
	overlay.on_dismiss_loss.connect(handle_dismiss_loss)
	
	overlay.high_scores_menu.request_dismiss.connect(overlay.on_dismiss_highscores.emit)
	

	
func handle_dismiss_loss() -> void:
	_game_state_holder.clear()
	_music.play_menu_track()
	overlay.update()
	
