extends Node2D
class_name AudioManager

func _on_play_audio(audio: AudioStream, shift_pitch: bool) -> void:
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = audio
	if shift_pitch:
		audio_player.pitch_scale = randf_range(0.85, 1.11)

	audio_player.play()
	audio_player.finished.connect(func(): audio_player.queue_free()) 