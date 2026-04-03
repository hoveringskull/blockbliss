class_name HighScore

var name: String 
var score: int

func _init(nm: String, scr: int):
	name = nm 
	score = scr
	
func to_dict():
	var json_dict = {"name": name, "score": score}
	return json_dict
