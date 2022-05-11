extends Node2D

onready var timer = get_node("Timer")
onready var tap_area = get_node("Tap Area")
onready var collision_bar_one = get_node("Tap Area/CollisionShape2D")

var gesture_started : bool = false
var gesture_completed : bool = false
var dialogue : Dialogue

var rub_count = 0
export var goal_rub_count = 10
export var time_to_complete = 5

signal gesture_completed

func _ready():
	tap_area.visible = false
	pass

func initiate_gesture(dialogue_resource : Dialogue):
	tap_area.visible = true
	if dialogue_resource:
		dialogue = dialogue_resource
	else:
		print("no dialogue resource")
	

func start_gesture_detection():
	gesture_started = true
	print("gesture started")
	timer.start(time_to_complete)
	yield(timer, "timeout")
	stop_gesture_detection()

func stop_gesture_detection():
	if rub_count >= goal_rub_count:
		complete_gesture_game()
		print("gesture completed")
	else:
		gesture_started = false
		rub_count = 0
		Audio.play_event_SFX(Audio.sfx.gesture_failed)
		print("gesture failed")
	print("collected gestures is ", rub_count)
	
func complete_gesture_game():
	dialogue.gesture_completed = true
	emit_signal("gesture_completed")
	queue_free()

func collider_visibilitiy_toggle():
	collision_bar_one.disabled = true
	yield(get_tree().create_timer(0.2),"timeout")
	if collision_bar_one:
		collision_bar_one.disabled = false
	
func _on_Tap_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		var input_speed = event.speed
		if dialogue.gesture_completed:
			return
		if !gesture_started:
			start_gesture_detection()
		elif gesture_started:
			if input_speed.y >= -300:
				return
			else:
				Audio.play_interact_SFX(Audio.sfx.next_dialogue)
				rub_count += 1
				collider_visibilitiy_toggle()
	
