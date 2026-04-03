class_name GameConstants

static var HEIGHT: int = 20
static var WIDTH: int = 10
static var TILE_COUNT: int = HEIGHT * WIDTH
static var TILE_DROP_SPEEDUP: float = 12.0 # how much faster tiles go if you're pressing down
static var TILE_SIZE: int = 32
static var DIFFICULTY_RAMP = 25.0  # The higher it is, the slower the speed ramps up. Linear for now
static var SLIDE_TIME = 0.1 # Time between horizontal movements

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, FINISHED }
enum TILE { NONE, RED, BLUE, YELLOW }
