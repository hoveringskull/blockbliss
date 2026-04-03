extends Node

var score: int

func add_score(amount: int):
	score += amount
	Events.on_score_updated.emit(score)

func reset_score():
	score = 0
	Events.on_score_updated.emit(score)
