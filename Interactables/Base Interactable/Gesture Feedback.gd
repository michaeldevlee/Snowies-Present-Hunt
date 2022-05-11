extends Node2D

var gesture_feedback : Node2D

func _ready():
	if get_child_count() > 0:
		gesture_feedback = get_child(0)

func play_gesture_feedback():
	if gesture_feedback != null && gesture_feedback.is_in_group("Gesture_Feedback"):
		gesture_feedback.play_feedback()
	else:
		print("this interactable does not have a gesture feedback")

