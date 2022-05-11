extends Node2D

var sparkle = preload("res://Background/Background Scenes/Decorations/Sparkle/Sparkle.tscn")

func play_sparkle():
	var sparkle_instance = sparkle.instance()
	add_child(sparkle_instance)
	sparkle_instance.global_position = get_global_mouse_position()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			print("sparkle")
			play_sparkle()
	
	if event is InputEventMouseButton:
		if event.pressed:
			print("sparkle")
			play_sparkle()
