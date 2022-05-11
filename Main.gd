extends Node2D

onready var cut_scene_manager = get_node("Snowie")
onready var GUI : Control = get_node("UI/GUI") as Control
onready var main_interactables = get_node("Interact Layer/Main Interactables")
onready var present_spawner = get_node("Presents")
onready var menus = get_node("Menus")
onready var timer = get_node("UI/Timer")

export (String, FILE, "*.tscn") var title_screen
export var game_time : int = 300

var all_presents_found : bool = false

enum game_states {NOT_STARTED, STARTED, ENDED}
var current_state = game_states.NOT_STARTED


func _ready():
	reset_global_variables()
	initialize_signals()
	store_main_interactables()
	toggle_timer_visibility(false)
	start_cut_scene("INTRO")
	disable_clickable_areas()
	turn_off_arrow_visibility()
	

func start_game():
	activate_clickable_areas()
	turn_on_arrow_visibility()
	toggle_timer_visibility(true)
	timer.start_timer(game_time)
	Audio.play_music(Audio.music.snowies_house)
	

func end_game(all_presents_found : bool):
	current_state = game_states.ENDED
	turn_off_arrow_visibility()
	toggle_timer_visibility(false)
	disable_clickable_areas()
	if all_presents_found == false:
		game_over()
	else:
		win_game()

func start_cut_scene(cut_scene_type : String):
	cut_scene_manager.begin_cut_scene(cut_scene_type)

func store_main_interactables():
	MainGameEvents.main_interactables_list = main_interactables.get_children()

func process_interactable(interactable):
	if GlobalClickEvents.click_buffer_on == false:
		GUI.initiate_dialogue(interactable)

func initiate_cut_scene_dialogue(dialogue : Node2D):
	GUI.initiate_dialogue(dialogue)

func check_acquired_all_presents():
	for interactable in MainGameEvents.main_interactables_list:
		if MainGameEvents.acquired_interactables.has(interactable):
			print("the main list has ", interactable)
			continue
		else:
			print(timer.is_timer_stopped)
			if timer.get_node("HBoxContainer/Game Timer").is_stopped():
				print("you're missing ", interactable)
				all_presents_found = false
				end_game(all_presents_found)
				return
			return
	all_presents_found = true
	end_game(all_presents_found)
	print("has all interactables")

func add_presents_under_tree_and_check():
	print("added present")
	present_spawner.create_present()
	check_acquired_all_presents()

func win_game():
	start_cut_scene("WIN")
	
func game_over():
	start_cut_scene("GAME_OVER")

func show_game_end_screen(game_state : String):
	if game_state == "LOSE":
		menus.show_game_over_screen()
	elif game_state == "WIN":
		menus.show_win_screen()

func reset_game():
	if current_state == game_states.ENDED:
		print("reset game")
		cut_scene_manager.fade_out()
		yield(cut_scene_manager.transition_animator,"animation_finished")
		Audio.background_music_player.stop()
		get_tree().change_scene(title_screen)

func reset_GUI():
	GUI.reset_UI()

func _on_Game_Timer_timeout():
	check_acquired_all_presents()

func activate_clickable_areas():
	get_tree().call_group("Interactable", "add_clickable_area_visibility")
	get_tree().call_group("Room", "add_clickable_area_visibility")

func disable_clickable_areas():
	get_tree().call_group("Interactable", "remove_clickable_area_visibility")
	get_tree().call_group("Room", "remove_clickable_area_visibility")

func toggle_timer_visibility(on_or_off : bool):
	timer.visible = on_or_off

func turn_off_arrow_visibility():
	get_tree().call_group("Arrow", "visibility_off")

func turn_on_arrow_visibility():
	get_tree().call_group("Arrow", "visibility_on")

func reset_global_variables():
	MainGameEvents.main_interactables_list.clear()
	MainGameEvents.acquired_interactables.clear()
	MainGameEvents.gesture_started = false
	
func initialize_signals():
	GlobalClickEvents.connect("interactable_clicked", self, "process_interactable")
	GlobalClickEvents.connect("cut_scene_started", self, "initiate_cut_scene_dialogue")
	GlobalClickEvents.connect("present_found", self, "add_presents_under_tree_and_check")
	GlobalClickEvents.connect("cut_scene_skipped", self, "reset_GUI")
	MainGameEvents.connect("intro_cut_scene_ended", self, "start_game")
	MainGameEvents.connect("restart_game_initiated", self, "reset_game")
	MainGameEvents.connect("end_game_cut_scene_ended", self, "show_game_end_screen")
