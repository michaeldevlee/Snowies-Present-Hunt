extends Control

onready var tween = get_node("Tween")
var tween_time = 0.2
var is_current_screen : bool

func appear():
	if !is_current_screen:
		is_current_screen = true
		var current_pos = rect_position
		var new_pos = current_pos + Vector2(0, -1000)
		tween.interpolate_property(self, "rect_position", current_pos, new_pos, tween_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		tween.start()

func disappear():
	if is_current_screen:
		is_current_screen = false
		var current_pos = rect_position
		var new_pos = current_pos + Vector2(0, 1000)
		tween.interpolate_property(self, "rect_position", current_pos, new_pos, tween_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		tween.start()

