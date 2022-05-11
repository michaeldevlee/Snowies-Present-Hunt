extends Node2D

var sparkle = preload("res://Background/Background Scenes/Decorations/Sparkle/Sparkle.tscn")


func play_sparkle():
	var sparkle_instance = sparkle.instance()
	add_child(sparkle_instance)
	sparkle_instance.position = get_global_mouse_position()
	
