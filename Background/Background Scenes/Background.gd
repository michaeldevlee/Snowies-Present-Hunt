extends Node2D

onready var transition_area_a = get_node("Transition Area A/CollisionShape2D")
onready var transition_area_b = get_node("Transition Area B/CollisionShape2D")
onready var interaction_area_A = get_node("Transition Area A")
onready var interaction_area_B = get_node("Transition Area B")

export var room_exit_resource : Resource

func _ready():
	var room_groups = get_groups()
	if room_groups.has("Corner"):
		transition_area_b.disabled = true

func add_clickable_area_visibility():
	interaction_area_A.visible = true
	interaction_area_B.visible = true

func remove_clickable_area_visibility():
	interaction_area_A.visible = false
	interaction_area_B.visible = false

func _on_Transition_Area_A_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			GlobalClickEvents.emit_signal("room_transition_initiated", room_exit_resource, "A")
			print("transition to next room")
			
	
	if event is InputEventScreenTouch:
		if event.pressed:
			GlobalClickEvents.emit_signal("room_transition_initiated", room_exit_resource, "A")


func _on_Transition_Area_B_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			GlobalClickEvents.emit_signal("room_transition_initiated", room_exit_resource, "B")
	
	if event is InputEventScreenTouch:
		if event.pressed:
			GlobalClickEvents.emit_signal("room_transition_initiated", room_exit_resource, "B")
