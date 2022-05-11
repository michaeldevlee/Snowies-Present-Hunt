extends Control

onready var tween = get_node("Tween")
var tween_time = 0.2

func appear():
	var current_pos = rect_position
	var new_pos = current_pos + Vector2(0, -1000)
	visible = true
	tween.interpolate_property(self, "rect_position", current_pos, new_pos, tween_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()

func disappear():
	var current_pos = rect_position
	var new_pos = current_pos + Vector2(0, 1000)
	visible = true
	tween.interpolate_property(self, "rect_position", current_pos, new_pos, tween_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
