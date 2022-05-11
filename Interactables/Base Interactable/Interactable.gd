extends Node2D

onready var sprite = get_node("Sprite")
onready var gesture_feedback_handler = get_node("Gesture Feedback Handler")
onready var interaction_area = get_node("Interact Area")
onready var animation_player = get_node("Animation Player")
onready var light_bulb_animator = get_node("Light Bulb/Gesture Start Animator")

var name_of_interactable : String = name
var is_already_interacted_with : bool = false
var can_interact : bool = false
var events = {}
var gesture : Node2D

export var dialogue_resource : Resource

func _ready():
	register_general_signals()
	registerGestureSignals()
	remove_clickable_area_visibility()

func select_interactable():
	if can_interact and GlobalClickEvents.click_buffer_on == false:
		GlobalClickEvents.emit_signal("interactable_clicked", self)
		checkGestureCompletion()
	else:
		GlobalClickEvents.click_buffer_on = false

func start_gesture_detection():
	if gesture != null && gesture.is_in_group("Gesture"):
		if MainGameEvents.gesture_started == false:
			light_bulb_animator.play("Start Gesture")
			Audio.play_event_SFX(Audio.sfx.gesture_started)
			MainGameEvents.gesture_started = true
			gesture.initiate_gesture(dialogue_resource)
		else:
			print("currently on a gesture")
	else:
		print("no gesture to start")

func display_feedback():
	gesture_feedback_handler.play_gesture_feedback()

func checkGestureCompletion():
	if dialogue_resource:
			var gesture_completed = dialogue_resource.gesture_completed
			if !gesture_completed:
				start_gesture_detection()

func markGestureCompleted():
	var gesture_completed = dialogue_resource.gesture_completed
	gesture_completed = true
	MainGameEvents.gesture_started = false
	MainGameEvents.acquired_interactables.append(self)
	GlobalClickEvents.emit_signal("present_found")
	light_bulb_animator.play("Gesture Finished")
	animation_player.play("Gesture Feedback")
	Audio.play_interact_SFX(Audio.sfx.gesture_completed)

func _on_Interact_Area_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
			select_interactable()
		else:
			select_interactable()
			events.erase(event.index)
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Interact"):
			select_interactable()
	
	if event is InputEventScreenDrag:
		play_hover_animation()

func _on_Interact_Area_mouse_entered():
	can_interact = true
	#sprite.material.set_shader_param("width", 4)
	
	
func _on_Interact_Area_mouse_exited():
	can_interact = false
	#sprite.material.set_shader_param("width", 0)
	GlobalClickEvents.click_buffer_on = false

func register_general_signals():
	MainGameEvents.connect("clickable_area_initialized", self, "add_clickable_area_visibility")

func remove_clickable_area_visibility():
	interaction_area.visible = false

func add_clickable_area_visibility():
	interaction_area.visible = true

func play_idle_animation():
	animation_player.play("Idle")

func play_hover_animation():
	if self.is_in_group("Hoverable"):
		pass

func registerGestureSignals():
	for child in get_children():
		if child.is_in_group("Gesture"):
			gesture = child
			break
	if gesture:
		gesture.connect("gesture_completed", self, "markGestureCompleted")
		gesture.connect("gesture_feedback_initiated", self, "display_feedback")
				
