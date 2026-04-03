extends Node

const TOP_SCORE_COUNT = 3
var scores: Array[HighScore]

func _ready():
	load_scores()
	
func load_scores():
	#scores will be stored as a json files with each entry "name" "score
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	if file:
		var json_string = file.get_line()
		var score_dicts = JSON.parse_string(json_string)
		
		var scores_untyped = score_dicts.map(func (h): return HighScore.new(h["name"], h["score"]))
		for score in scores_untyped:
			scores.append(score)
	
	scores.sort_custom(func(a, b): return a.score > b.score)
	scores = scores.slice(0, TOP_SCORE_COUNT)
				
func save_scores():
	var score_dicts = scores.map(func (h): return h.to_dict())
	var json_string = JSON.stringify(score_dicts)
	var file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	file.store_line(json_string)
	
func add_score(value: HighScore):
	# TODO limit to TOP_SCORE_COUNT and sort
	scores.append(value)
	scores.sort_custom(func(a, b): return a.score > b.score)
	scores = scores.slice(0, TOP_SCORE_COUNT)
	save_scores()
