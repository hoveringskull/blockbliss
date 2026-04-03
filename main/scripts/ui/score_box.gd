extends PanelContainer

@export 
var score_display_label: Label

func _ready():
	bind_events()
	update_score(Player.score)
	
func bind_events():
	Events.on_score_updated.connect(update_score)

func update_score(value: int):
	score_display_label.text = str(value).lpad(8, "0")
