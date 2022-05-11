extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func queue_free():
	yield(anim_player,"animation_finished")
	queue_free()
