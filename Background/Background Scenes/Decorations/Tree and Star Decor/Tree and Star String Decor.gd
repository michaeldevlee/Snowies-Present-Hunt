extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func play_spin_animation():
	anim_player.play("Spin")

func remove_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = true

func add_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and !anim_player.is_playing():
			Audio.play_event_SFX(Audio.sfx.tree_decor_touch)
			play_spin_animation()
	elif event is InputEventMouseButton:
		if event.button_index == 1 and !anim_player.is_playing():
			play_spin_animation()
			Audio.play_event_SFX(Audio.sfx.tree_decor_touch)
