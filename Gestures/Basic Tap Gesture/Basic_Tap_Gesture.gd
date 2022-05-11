extends Node2D

onready var timer = get_node("Timer")
onready var tap_area = get_node("Tap Area")

var gesture_started : bool = false
var gesture_completed : bool = false
var dialogue : Dialogue

var tap_count = 0
export var goal_tap_count = 10
export var time_to_complete = 3

signal gesture_completed
signal gesture_feedback_initiated

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
	timer.start(3)
	yield(timer, "timeout")
	stop_gesture_detection()

func stop_gesture_detection():
	if tap_count >= goal_tap_count:
		complete_gesture_game()
		print("gesture completed")
		queue_free()
	else:
		tap_count = 0
		print("gesture failed")
		Audio.play_interact_SFX(Audio.sfx.gesture_failed)
	gesture_started = false
	
func complete_gesture_game():
	dialogue.gesture_completed = true
	emit_signal("gesture_completed")

func _on_Tap_Area_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and !dialogue.gesture_completed:
		if Input.is_action_just_pressed("Interact"):
			if !gesture_started:
				start_gesture_detection()
			elif gesture_started:
				Audio.play_interact_SFX(Audio.sfx.next_dialogue)
				tap_count += 1
				emit_signal("gesture_feedback_initiated")
