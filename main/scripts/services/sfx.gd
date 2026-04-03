class_name SFX extends AudioStreamPlayer2D

enum Key {
	SELECT,
	IMPACT,
	CLEAR
}

@export var sounds: Array[AudioStream]

func request_sound(key: SFX.Key):
	stream = sounds[int(key)]
	pitch_scale = randf_range(0.8, 1.2)
	play()
	
