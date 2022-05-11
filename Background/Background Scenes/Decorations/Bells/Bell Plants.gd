extends Node2D

onready var anim_player = get_node("AnimationPlayer")

var can_interact : bool = true

func remove_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = true

func add_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion || InputEventScreenTouch:
		if can_interact == true:
			Audio.play_event_SFX(Audio.sfx.bell_ring)
			print(Audio.sfx.bell_ring)
			can_interact = false
			anim_player.playback_speed = 3
			yield(get_tree().create_timer(1), "timeout")
			anim_player.playback_speed = 1
			yield(get_tree().create_timer(1), "timeout")
			can_interact = true
