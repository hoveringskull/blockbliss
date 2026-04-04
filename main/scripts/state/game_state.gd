class_name GameState

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, LOST }

var status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var last_status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var active_time: float
var last_drop_time: float
var last_slide_time: float
var current_active_shape: Shape
var next_active_shape: Shape
var gravity: float = 0.5 # seconds per tile drop
var speed_up: bool = false
var score: int
# grid is an array of tiles with 0 representing empty higher values representing colored blocks 
var grid: Array[int]

var difficulty_coefficient: float:
	get: return 1 + (active_time / GameConstants.DIFFICULTY_RAMP) 

var total_gravity: float:
	get:
		if speed_up:
			return gravity / difficulty_coefficient / GameConstants.TILE_DROP_SPEEDUP
		return gravity / difficulty_coefficient
