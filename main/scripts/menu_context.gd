class_name MenuContext extends Node

signal request_quit
signal request_start_game
signal request_scores

@export var overlay: MenuOverlay

var _sfx: SFXPlayer
var _music: MusicPlayer
var _high_scores: HighScores
	
func build_services() -> void:
	_high_scores = HighScores.new()
	add_child(_high_scores)

func bind_services(sfx: SFXPlayer, music: MusicPlayer) -> void:
	_sfx = sfx
	_music = music
	
	overlay.main_menu.initialize(_music, _sfx)
	overlay.high_scores_menu.initialize(_high_scores)
	overlay.end_screen.initialize(_high_scores)

func connect_signals() -> void:
	overlay.main_menu.request_start_game.connect(request_start_game.emit)
	overlay.main_menu.request_quit.connect(request_quit.emit)
