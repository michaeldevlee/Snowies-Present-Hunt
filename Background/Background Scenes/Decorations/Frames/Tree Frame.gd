extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func play_random_animation():
	var animation_list = anim_player.get_animation_list()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_index = rng.randi_range(0, animation_list.size()-1)
	var chosen_animation = animation_list[random_index]
	print(chosen_animation)
	anim_player.play(chosen_animation)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and !anim_player.is_playing():
			Audio.play_event_SFX(Audio.sfx.tree_display_touch)
			play_random_animation()
	if event is InputEventMouseButton:
		if event.button_index == 1 and !anim_player.is_playing():
			Audio.play_event_SFX(Audio.sfx.tree_display_touch)
			play_random_animation()
