extends Node2D

onready var timer = get_node("Timer")
onready var tap_area = get_node("Tap Area")
onready var collision_bar_one = get_node("Tap Area/CollisionShape2D")
onready var collision_bar_two = get_node("Tap Area/CollisionShape2D2")

var gesture_started : bool = false
var gesture_completed : bool = false
var dialogue : Dialogue

var rub_count = 0
export var goal_rub_count = 40
export var time_to_complete = 3

signal gesture_completed

func _ready():
	tap_area.visible = false

func initiate_gesture(dialogue_resource : Dialogue):
	tap_area.visible = true
	if dialogue_resource:
		dialogue = dialogue_resource
	else:
		print("no dialogue resource")
	

func start_gesture_detection():
	gesture_started = true
	print("gesture started")
	timer.start(5)
	yield(timer, "timeout")
	stop_gesture_detection()

func stop_gesture_detection():
	if rub_count >= goal_rub_count:
		complete_gesture_game()
		print("gesture completed")
	else:
		gesture_started = false
		rub_count = 0
		print("gesture failed")
		Audio.play_interact_SFX(Audio.sfx.gesture_failed)
	print("collected gestures is ", rub_count)
	
func complete_gesture_game():
	dialogue.gesture_completed = true
	emit_signal("gesture_completed")
	queue_free()

func collider_visibilitiy_switch():
	collision_bar_one.disabled = !collision_bar_one.disabled
	collision_bar_two.disabled = !collision_bar_two.disabled
	
func _on_Tap_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion || InputEventScreenDrag:
		if dialogue.gesture_completed:
			return
		if !gesture_started:
			start_gesture_detection()
			collider_visibilitiy_switch()
		elif gesture_started:
			Audio.play_interact_SFX(Audio.sfx.next_dialogue)
			rub_count += 1
			collider_visibilitiy_switch()
	
