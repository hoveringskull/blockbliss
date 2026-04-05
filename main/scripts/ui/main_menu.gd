class_name MainMenu extends PanelContainer

signal request_start_game
signal request_quit
signal request_scores

@export var start_button: Button
@export var scores_button: Button
@export var quit_button: Button

var _music: MusicPlayer
var _sfx: SFXPlayer
	
func initialize(music: MusicPlayer, sfx: SFXPlayer) -> void:
	bind_services(music, sfx)
	bind_events()
	
func bind_services(music: MusicPlayer, sfx: SFXPlayer) -> void:
	_music = music
	_sfx = sfx	

func bind_events() -> void:
	start_button.pressed.connect(on_press_start)
	
	scores_button.pressed.connect(on_press_scores)

	quit_button.pressed.connect(on_press_quit)

	Events.request_hide_menu.connect(hide_menu)
	Events.request_dismiss_loss.connect(show_menu)
	Events.request_dismiss_highscores.connect(show_menu)
	
	_music.play_menu_track()


func on_press_start() -> void:
	_sfx.request_sound(SFXPlayer.Key.SELECT)
	request_start_game.emit()

func on_press_scores() -> void:
	_sfx.request_sound(SFXPlayer.Key.SELECT)
	request_scores.emit()
	hide()

func on_press_quit() -> void:
	_sfx.request_sound(SFXPlayer.Key.SELECT)
	request_quit.emit()

func hide_menu() -> void:
	visible = false
	
func show_menu() -> void:
	visible = true
	_music.play_menu_track()
