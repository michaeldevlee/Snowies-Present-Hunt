extends Node2D

onready var timer = get_node("Timer")
onready var tap_area = get_node("Tap Area")
onready var collision_bar_one = get_node("Tap Area/CollisionShape2D")
onready var collision_bar_two = get_node("Tap Area/CollisionShape2D2")
onready var collision_bar_three = get_node("Tap Area/CollisionShape2D3")

var gesture_started : bool = false
var gesture_completed : bool = false
var dialogue : Dialogue

var tap_areas : Array
var tap_areas_index : int = 0
export var goal_tap_count = 10
export var time_to_complete = 7

signal gesture_completed

func _ready():
	tap_areas = tap_area.get_children()
	tap_area.visible = false

func initiate_gesture(dialogue_resource : Dialogue):
	tap_area.visible = true
	print("started ", name)
	if dialogue_resource:
		dialogue = dialogue_resource
	else:
		print("no dialogue resource")
	

func start_gesture_detection():
	if timer.is_stopped():
		register_signals()
		gesture_started = true
		reset_colliders()
		print("gesture started")
		timer.start(time_to_complete)
	else:
		return

func stop_gesture_detection():
	gesture_started = false
	print("finished gesture timer")
	for collider in tap_areas:
		if collider.disabled == false:
			reset_gesture_game()
			Audio.play_interact_SFX(Audio.sfx.gesture_failed)
			print("gesture failed")
			return
	complete_gesture_game()
	print("gesture completed")			
	
	
func complete_gesture_game():
	dialogue.gesture_completed = true
	emit_signal("gesture_completed")
	queue_free()

func reset_gesture_game():
	tap_areas_index = 0
	gesture_started = false
	timer.stop()
	reset_colliders()
	toggle_gesture_visiblility(true)

func toggle_gesture_visiblility(on_or_off : bool):
	visible = on_or_off

func reset_colliders():
	for collider in tap_areas:
		collider.disabled = false

func register_gesture_input(event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if dialogue.gesture_completed:
				return
			if !gesture_started:
				start_gesture_detection()
			elif gesture_started:
				if tap_areas_index != shape_idx:
					print(tap_areas_index)
					print(shape_idx)
					reset_gesture_game()
					print("stopping the gesture")
				else:
					Audio.play_interact_SFX(Audio.sfx.next_dialogue)
					tap_areas_index += 1
					tap_areas[shape_idx].disabled = true
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if dialogue.gesture_completed:
				return
			if !gesture_started:
				start_gesture_detection()
			elif gesture_started:
				if tap_areas_index != shape_idx:
					reset_gesture_game()
					return
				else:
					Audio.play_interact_SFX(Audio.sfx.next_dialogue)
					tap_areas_index += 1
					tap_areas[shape_idx].disabled = true

func _on_Tap_Area_input_event(viewport, event, shape_idx):
	register_gesture_input(event, shape_idx)

func register_signals():
	timer.connect("timeout", self, "stop_gesture_detection")
