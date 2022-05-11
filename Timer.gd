extends Control

onready var timer = get_node("HBoxContainer/Game Timer")
onready var label = get_node("HBoxContainer/Label")

var is_timer_stopped : bool

func start_timer(seconds):
	timer.start(seconds)
	is_timer_stopped = false

func check_timer_has_stopped():
	if timer.is_stopped():
		is_timer_stopped = true
	
	return is_timer_stopped

func update_timer():
	if !timer.is_stopped():
		var minutes = fmod(timer.time_left,60*60)/60
		var seconds = fmod(timer.time_left,60)
		label.set_text("%02d:%02d" % [minutes, seconds])
		is_timer_stopped = false

func _process(delta):
	update_timer()

func _on_Game_Timer_timeout():
	is_timer_stopped = true
