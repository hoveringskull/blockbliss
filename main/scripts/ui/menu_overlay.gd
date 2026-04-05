class_name MenuOverlay extends Node

@export var main_menu: MainMenu
@export var high_scores_menu: HighScoresMenu
@export var end_screen: EndScreen

func _ready() -> void:
	main_menu.request_scores.connect(high_scores_menu.show_menu)
