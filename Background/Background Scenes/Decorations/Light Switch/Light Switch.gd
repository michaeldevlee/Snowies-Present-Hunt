extends Node2D

onready var anim_player = get_node("AnimationPlayer")

var switch_on : bool = false

func remove_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = true

func add_clickable_area_visibility():
	get_node("Area2D/CollisionShape2D").disabled = false

func toggle_switch():
	if !switch_on:
		switch_on = true
		anim_player.play("Switch On")
	else:
		switch_on = false
		anim_player.play("Switch off")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			toggle_switch()
	if event is InputEventMouseButton:
		if event.button_index == 1:
			toggle_switch()
