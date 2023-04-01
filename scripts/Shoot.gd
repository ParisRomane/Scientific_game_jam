extends AudioStreamPlayer

func play_pitch():
	randomize()
	pitch_scale = randf_range(0.8, 1.2)
	play()
