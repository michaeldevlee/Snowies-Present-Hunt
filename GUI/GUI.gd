extends Control

onready var display_text = get_node("MarginContainer/Dialogue Box/Dialogue Bubble/MarginContainer/HBoxContainer/ColorRect2/MarginContainer/VBoxContainer/Dialogue")
onready var display_name = get_node("MarginContainer/Dialogue Box/Dialogue Bubble/MarginContainer/HBoxContainer/ColorRect2/MarginContainer/VBoxContainer/Name")
onready var character_portrait = get_node("MarginContainer/Dialogue Box/Dialogue Bubble/MarginContainer/HBoxContainer/Dialogue Picture")
onready var next_dialogue_button = get_node("AnimatedSprite")
onready var tween = get_node("Tween")

var is_in_dialogue : bool = false
var dialogue_index : int = 0
var selected_dialogue_resource : Dialogue
var selected_dialogue : Array
var dialogue_length : int = 0
var finished_dialogue : bool = false


func initiate_dialogue(interactable : Node2D):
	if is_in_dialogue || finished_dialogue:
		return
	
	selected_dialogue_resource = interactable.dialogue_resource

	if !selected_dialogue_resource.is_already_visited:
		selected_dialogue = selected_dialogue_resource.dialogue_text as Array
	else:
		selected_dialogue = selected_dialogue_resource.dialogue_text_interacted as Array

	dialogue_length = selected_dialogue.size()
	
	if selected_dialogue:
		is_in_dialogue = true
		visible = true
		display_name.set_text(interactable.name)
		display_text.set_text(selected_dialogue[dialogue_index])
		display_text.set_percent_visible(0)
		tween.interpolate_property(display_text, "percent_visible", 0,1,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		next_dialogue_button.visible = true
		finished_dialogue = true
	else:
		print ("there is no dialogue in ", selected_dialogue)
		return

func advance_next_dialogue():
	next_dialogue_button.visible = false
	if finished_dialogue == false:
		if tween.is_active():
			tween.set_speed_scale(40)
	elif finished_dialogue == true and dialogue_length - 1 > dialogue_index:
		Audio.play_interact_SFX(Audio.sfx.next_dialogue)
		tween.set_speed_scale(2)
		dialogue_index += 1
		finished_dialogue = false
		display_text.set_percent_visible(0)
		display_text.set_text(selected_dialogue[dialogue_index])
		tween.interpolate_property(display_text, "percent_visible", 0,1,3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		finished_dialogue = true
		next_dialogue_button.visible = true
	elif finished_dialogue == true && dialogue_length - 1 == dialogue_index:
		if finished_dialogue:
			tween.set_speed_scale(1)
			reset_UI()
			Audio.play_interact_SFX(Audio.sfx.next_dialogue)
			if GlobalClickEvents.cut_scene_active == true:
				GlobalClickEvents.emit_signal("cut_scene_dialogue_block_ended")
			else:
				GlobalClickEvents.click_buffer_on = true
				selected_dialogue_resource.is_already_visited = true
			return

func reset_UI():
	is_in_dialogue = false
	dialogue_index = 0
	dialogue_length = 0
	finished_dialogue = false
	visible = false

func _process(delta):
	print(display_text.percent_visible)

func _input(event):
		if event is InputEventMouseButton:
			if Input.is_action_just_pressed("Interact"):
				if is_in_dialogue:
					advance_next_dialogue()
				else:
					GlobalClickEvents.click_buffer_on = false
				

