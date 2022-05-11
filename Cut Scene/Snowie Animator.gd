extends AnimationPlayer

func play_idle():
	play("Idle")

func play_walk():
	play("Walking")

func play_panic_run():
	playback_speed = 2
	play("Panicking")

func reset_speed():
	playback_speed = 1

func play_happy():
	pass

func play_worried():
	play("Worried")

func play_footstep():
	var footsteps = [
		Audio.sfx.snowie_footstep_1,
		Audio.sfx.snowie_footstep_2,
		Audio.sfx.snowie_footstep_3
	]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_index = rng.randi_range(0, footsteps.size()-1)
	Audio.play_event_SFX(footsteps[random_index])

func play_squeak():
	Audio.play_event_SFX(Audio.sfx.snowie_squeak)
