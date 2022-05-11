extends Node2D

onready var tween = get_node("Tween")
onready var camera = get_node("Camera2D")

var is_transitioning : bool = false
var transition_time : int = 1

func _ready():
	register_signals()

func move_to_next_room(room_directions : Room_Directions, exit_letter : String):
	if !is_transitioning:
		is_transitioning = true
		tween.interpolate_property(camera, "position", camera.position, camera.position + room_directions.room_direction_dictionary[exit_letter],transition_time,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		tween.start()
		yield(tween,"tween_completed")
		is_transitioning = false

func reset_position():
	camera.position = Vector2(0,0)

func register_signals():
	GlobalClickEvents.connect("room_transition_initiated", self, "move_to_next_room")
	MainGameEvents.connect("game_ended", self, "reset_position")
