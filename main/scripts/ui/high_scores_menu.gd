extends PanelContainer

@export var back_button: Button
@export var scores_parent: Control

func _ready():
	bind_events()
	load_scores()
	hide()
	

func bind_events():
	back_button.pressed.connect(handle_back_pressed)
	
	Events.request_menu_scores.connect(show_menu)

func show_menu():
	load_scores()
	show()

func handle_back_pressed():
	visible = false
	Events.request_dismiss_highscores.emit()

func load_scores():
	for child in scores_parent.get_children():
		child.queue_free()
	
	for score in HighScores.scores:
		var score_label: Label = Label.new()
		score_label.text = score.name.rpad(12, ".") + "........" + str(score.score).lpad(10, "0")
		scores_parent.add_child(score_label)
