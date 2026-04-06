class_name GameCamera extends Camera2D

const MAX_SHAKE: float = 5.0

var home_position: Vector2
var current_shake: Tween

# TODO: this might be dumb to add as a dependency here
var _grid_controller: GridController # optional


func initialize(grid_controller: GridController) -> void:
	bind_services(grid_controller)

	home_position = get_window().size / 2
	position = home_position
	
	if _grid_controller:
		_grid_controller.on_row_clear.connect(shake_screen)
	
func bind_services(grid_controller: GridController) -> void:
	_grid_controller = grid_controller

func shake_screen(_row: int, _values: Array[int]) -> void:
	if not current_shake or not current_shake.is_running():
		current_shake = get_tree().create_tween()
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE), randf_range(-MAX_SHAKE, MAX_SHAKE)), 0.05)
		current_shake.tween_property(self, "position", home_position, 0.05)

	
