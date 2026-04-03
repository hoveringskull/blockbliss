extends PanelContainer

const MAX_NAME_INPUT = 10

@export var dismiss_button: Button
@export var score: Label
@export var name_input: LineEdit

func _ready():
	bind_events()
	visible = false

func bind_events():
	Events.on_game_lost.connect(handle_game_lost)
	
	dismiss_button.pressed.connect(dismiss_loss)
	
func handle_game_lost():
	visible = true
	score.text = str(Player.score)

func dismiss_loss():
	visible = false
	HighScores.add_score(HighScore.new(name_input.text.substr(0, MAX_NAME_INPUT), Player.score))
	Events.request_dismiss_loss.emit()
