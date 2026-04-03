extends PanelContainer

func _ready():
	bind_events()

func bind_events():
	var start_button = $layout_margin/layout_options/start
	start_button.pressed.connect(on_press_start)
	
	var scores_button = $layout_margin/layout_options/scores
	scores_button.pressed.connect(on_press_scores)

	var quit_button = $layout_margin/layout_options/quit
	quit_button.pressed.connect(on_press_quit)

	Events.request_hide_menu.connect(hide_menu)
	Events.request_dismiss_loss.connect(show_menu)
	Events.request_dismiss_highscores.connect(show_menu)
	
	Music.play_menu_track()


func on_press_start():
	Sfx.request_sound(SFX.Key.SELECT)
	Events.request_start_game.emit()

func on_press_scores():
	Events.request_menu_scores.emit()
	hide()

func on_press_quit():
	Events.request_quit.emit()

func hide_menu():
	visible = false
	
func show_menu():
	visible = true
	Music.play_menu_track()
