class_name GameOverlay extends Node

@export var score_box: ScoreBox
@export var next_piece_renderer: NextPieceRenderer 

func initialize(gsh: GameStateHolder,\
		score_controller: ScoreController,\
		grid_controller: GridController) -> void:
	score_box.initialize(gsh, score_controller)
	next_piece_renderer.initialize(gsh, grid_controller)
