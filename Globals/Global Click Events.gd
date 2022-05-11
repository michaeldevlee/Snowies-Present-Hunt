extends Node2D

var selected_interactable = null
var cut_scene_active : bool = false
var click_buffer_on : bool = false

signal interactable_clicked(interactable)
signal interactable_finished(interactable)

signal cut_scene_started(dialogue)
signal cut_scene_skipped
signal cut_scene_dialogue_block_ended

signal room_transition_initiated(room_directions, exit_letter)

signal present_found

