class_name HighScores extends Node

const TOP_SCORE_COUNT: int = 3
var scores: Array[HighScore]

func _ready() -> void:
	load_scores()
	
func load_scores() -> void:
	#scores will be stored as a json files with each entry "name" "score
	var file: FileAccess = FileAccess.open("user://scores.json", FileAccess.READ)
	if file:
		var json_string: String = file.get_line()
		var score_dicts: Array = JSON.parse_string(json_string)
		
		var scores_untyped: Array = score_dicts.map(variant_dict_to_highscore)
		for score: HighScore in scores_untyped:
			scores.append(score)
	
	scores.sort_custom(func(a: HighScore, b: HighScore) -> bool: return a.score > b.score)
	scores = scores.slice(0, TOP_SCORE_COUNT)
				
func save_scores() -> void:
	var score_dicts: Array = scores.map(func (h: HighScore) -> Dictionary: return h.to_dict())
	var json_string: String = JSON.stringify(score_dicts)
	var file: FileAccess = FileAccess.open("user://scores.json", FileAccess.WRITE)
	file.store_line(json_string)
	
func add_score(value: HighScore) -> void:
	# TODO limit to TOP_SCORE_COUNT and sort
	scores.append(value)
	scores.sort_custom(func(a: HighScore, b: HighScore) -> bool: return a.score > b.score)
	scores = scores.slice(0, TOP_SCORE_COUNT)
	save_scores()

func variant_dict_to_highscore(dict: Dictionary) -> HighScore:
		if dict["name"] is String and dict["score"] is float:
			@warning_ignore_start("unsafe_cast")
			var nm: String = dict["name"] as String
			var sc: int = dict["score"] as int
			@warning_ignore_restore("unsafe_cast")
			return HighScore.new(nm, sc)
		return null
