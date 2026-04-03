extends Camera2D

var home_position: Vector2
var current_shake: Tween

const MAX_SHAKE: float = 5.0

func _ready():
	home_position = get_window().size / 2
	position = home_position
	Events.on_row_clear.connect(shake_screen)

func shake_screen(_row, _values):
	if not current_shake or not current_shake.is_running():
		current_shake = get_tree().create_tween()
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position, 0.05)

	
