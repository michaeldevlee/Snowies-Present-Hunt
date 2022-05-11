extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func play_cycle_animation():
	anim_player.play("Cycle")

func play_rub_animation():
	anim_player.play("Rub")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and !anim_player.is_playing():
			play_cycle_animation()
	elif event is InputEventMouseButton:
		if event.button_index == 1 and !anim_player.is_playing():
			play_cycle_animation()
	elif event is InputEventScreenDrag:
		var input_speed = event.speed
		if !anim_player.is_playing() and input_speed.y < -300:
			play_rub_animation()
	elif event is InputEventMouseMotion:
		var input_speed = event.speed
		if !anim_player.is_playing() and input_speed.y < -300:
			play_rub_animation()
