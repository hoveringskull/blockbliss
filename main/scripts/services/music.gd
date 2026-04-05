class_name MusicPlayer extends AudioStreamPlayer2D

@export var menu_track: AudioStream
@export var loss_track: AudioStream
@export var game_tracks: Array[AudioStream]

func play_menu_track() -> void:
	if finished.is_connected(play_game_track):
		finished.disconnect(play_game_track)
		
	if not finished.is_connected(play_menu_track):
		finished.connect(play_menu_track)
		stream = menu_track
		play()

func play_loss_track() -> void:
	if finished.is_connected(play_game_track):
		finished.disconnect(play_game_track)
		
	if not finished.is_connected(play_menu_track):
		finished.connect(play_menu_track)
		stream = loss_track
		play()

	
func play_game_track() -> void:
	if finished.is_connected(play_menu_track):
		finished.disconnect(play_menu_track)
	finished.connect(play_game_track)
	stream = game_tracks.pick_random()
	play()
	
