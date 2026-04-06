class_name HighScoresMenu extends PanelContainer

signal request_dismiss

@export var back_button: Button
@export var scores_parent: Control

var _high_scores: HighScores

func initialize(high_scores: HighScores) -> void:
	bind_events()
	bind_services(high_scores)
	load_scores()
	hide()

func bind_events() -> void:
	back_button.pressed.connect(handle_back_pressed)
	
func bind_services(high_scores: HighScores) -> void:
	_high_scores = high_scores
	
func show_menu() -> void:
	load_scores()
	show()


func handle_back_pressed() -> void:
	visible = false
	request_dismiss.emit()

func load_scores() -> void:
	for child: Node in scores_parent.get_children():
		child.queue_free()
	
	for score: HighScore in _high_scores.scores:
		var score_label: Label = Label.new()
		score_label.text = score.name.rpad(12, ".") + "........" + str(score.score).lpad(10, "0")
		scores_parent.add_child(score_label)
