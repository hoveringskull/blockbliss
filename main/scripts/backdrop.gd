extends Sprite2D

@export var colors: Array[Color]
@export var transition_time: float
@export var transition_time_fudge: float

var current_tween: Tween

func _ready():
	tween_random()


func tween_random():
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "modulate", colors.pick_random(),\
		randf_range(transition_time - transition_time_fudge, transition_time + transition_time_fudge))
	current_tween.tween_callback(tween_random)
