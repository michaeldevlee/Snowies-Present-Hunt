extends Node2D

onready var timer = get_node("Timer")
onready var tap_area = get_node("Tap Area")
onready var collision_bar_one = get_node("Tap Area/CollisionShape2D")
onready var collision_bar_two = get_node("Tap Area/CollisionShape2D2")
onready var collision_bar_three = get_node("Tap Area/CollisionShape2D3")

var gesture_started : bool = false
var gesture_completed : bool = false
var dialogue : Dialogue

var tap_count = 0
var tap_areas : Array
var tap_areas_count : int
export var goal_tap_count = 10
export var time_to_complete = 7

signal gesture_completed

func _ready():
	tap_areas = tap_area.get_children()
	tap_areas_count = tap_areas.size()
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
	timer.start(time_to_complete)
	yield(timer, "timeout")
	stop_gesture_detection()

func stop_gesture_detection():
	for collider in tap_areas:
		if collider.disabled == false:
			reset_gesture_game()
			Audio.play_interact_SFX(Audio.sfx.gesture_failed)
			print("gesture failed")
			return
				
	complete_gesture_game()
	print("gesture completed")
	print("collected gestures is ", tap_count)
	
func complete_gesture_game():
	dialogue.gesture_completed = true
	emit_signal("gesture_completed")
	queue_free()

func reset_gesture_game():
	collider_visibility_reset()
	tap_count = 0
	gesture_started = false

func collider_visibility_reset():
	for collider in tap_areas:
		collider.disabled = false

func collider_visibilitiy_off(collider : CollisionShape2D):
	if collider:
		collider.disabled = true

func register_gesture_input(event, shape_idx):
	if event is InputEventMouseButton:
		print(shape_idx)
		if event.pressed and event.button_index == 1:
			if dialogue.gesture_completed:
				return
			if !gesture_started:
				start_gesture_detection()
			elif gesture_started:
				if tap_count >= 10:
					collider_visibilitiy_off(tap_areas[shape_idx])
					tap_count = 0
				Audio.play_interact_SFX(Audio.sfx.next_dialogue)
				tap_count += 1
	
	if event is InputEventScreenTouch:
		if !gesture_started:
			start_gesture_detection()
		elif gesture_started:
			if tap_count >= 10:
				collider_visibilitiy_off(tap_areas[shape_idx])
				tap_count = 0
			Audio.play_interact_SFX(Audio.sfx.next_dialogue)
			tap_count += 1

func _on_Tap_Area_input_event(viewport, event, shape_idx):
	register_gesture_input(event, shape_idx)
