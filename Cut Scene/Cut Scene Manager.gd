extends Node2D

var intro_dialogue_part_one: Resource = preload("res://Cut Scene/Dialogue Part One.tres")
var intro_dialogue_part_two: Resource = preload("res://Cut Scene/Dialogue Part Two.tres")
var game_over_dialogue_part_one: Resource = preload("res://Cut Scene/Game_Over_Dialogue_One.tres")
var game_over_dialogue_part_two: Resource
var win_dialogue_part_one: Resource = preload("res://Cut Scene/Win Dialogue Part One.tres")
var win_dialogue_part_two: Resource

onready var snowies_friends_sprites = get_node("Snowies Friends")
onready var cut_scene_animator = get_node("Cut Scene Animator")
onready var transition_animator = get_node("Transition Animator")
onready var snowie_animator = get_node("Snowie Animator")
onready var snowie = get_node("Snowie")
onready var skip_button = get_node("CanvasLayer/Skip Button")
onready var skip_button_BG = get_node("CanvasLayer/Skip Button/Skip Button BG")
onready var skip_button_text_animator = get_node("CanvasLayer/Skip Button/AnimationPlayer")

export (Resource) var dialogue_resource

var cut_scene_index = 0

enum cut_scenes {INTRO, GAME_OVER, WIN}
var current_cut_scene = null

func _ready():
	snowie.position += Vector2(0, 2000)
	register_signals()
	hide_friend_visibilitiy()

func hide_friend_visibilitiy():
	snowies_friends_sprites.visible = false

func begin_cut_scene(cut_scene_type : String):
	
	GlobalClickEvents.cut_scene_active = true
	var cut_scene = cut_scenes[cut_scene_type]
	current_cut_scene = cut_scene
	
	if cut_scene == cut_scenes.INTRO:
		fade_in()
		yield(transition_animator,"animation_finished")
		cut_scene_animator.play("1. Snowie Walk Into House")
	elif cut_scene == cut_scenes.GAME_OVER:
		fade_out()
		yield(transition_animator,"animation_finished")
		cut_scene_animator.play("1. GameOver Gather")
		MainGameEvents.emit_signal("game_ended")
		fade_in()
	elif cut_scene == cut_scenes.WIN:
		fade_out()
		yield(transition_animator,"animation_finished")
		MainGameEvents.emit_signal("game_ended")
		fade_in()
		yield(transition_animator,"animation_finished")
		cut_scene_animator.play("1. Win Speech")

func skip_cut_scene():
	if GlobalClickEvents.cut_scene_active == true:
		if current_cut_scene == cut_scenes.INTRO:
			fade_out()
			yield(transition_animator,"animation_finished")
			intro_cut_scene_terminate()
			fade_in()
		elif current_cut_scene == cut_scenes.GAME_OVER:
			fade_out()
			yield(transition_animator,"animation_finished")
			game_over_cut_scene_terminate()
			fade_in()
func start_dialogue_part_one():
	match current_cut_scene:
		cut_scenes.INTRO: 
			dialogue_resource = intro_dialogue_part_one
		cut_scenes.GAME_OVER:
			dialogue_resource = game_over_dialogue_part_one
		cut_scenes.WIN:
			dialogue_resource = win_dialogue_part_one
	
	GlobalClickEvents.emit_signal("cut_scene_started", self)
	cut_scene_index += 1

func start_dialogue_part_two():
	match current_cut_scene:
		cut_scenes.INTRO: 
			dialogue_resource = intro_dialogue_part_two
		cut_scenes.GAME_OVER:
			dialogue_resource = game_over_dialogue_part_two
		cut_scenes.WIN:
			dialogue_resource = win_dialogue_part_two
	
	GlobalClickEvents.emit_signal("cut_scene_started", self)
	cut_scene_index += 1


func start_intro_cut_scene_two():
	cut_scene_animator.play("2. Snowie Panicking")

func start_intro_cut_scene_three():
	cut_scene_animator.play("3. Snowie Leaves To Clean")

func intro_cut_scene_terminate():
	MainGameEvents.emit_signal("intro_cut_scene_ended")
	turn_off_skip_button_visibility()
	reset_animation_player()
	reset_cut_scene_index()
	move_player_off_screen()
	
func game_over_cut_scene_terminate():
	MainGameEvents.emit_signal("end_game_cut_scene_ended", "LOSE")
	reset_animation_player()
	reset_cut_scene_index()

func start_win_cut_scene_two():
	snowies_friends_sprites.play_win_animation()
	MainGameEvents.emit_signal("end_game_cut_scene_ended", "WIN")

func reset_animation_player():
	cut_scene_animator.seek(0, true)
	cut_scene_animator.stop()
	snowie_animator.stop()
	GlobalClickEvents.emit_signal("cut_scene_skipped")

func reset_cut_scene_index():
	cut_scene_index = 0
	GlobalClickEvents.cut_scene_active = false

func start_next_dialogue():
	if current_cut_scene == cut_scenes.INTRO:
		match cut_scene_index:
			1: start_intro_cut_scene_two()
			2: start_intro_cut_scene_three()
	elif current_cut_scene == cut_scenes.GAME_OVER:
		match cut_scene_index:
			1: game_over_cut_scene_terminate()
			2: pass
	elif current_cut_scene == cut_scenes.WIN:
		match cut_scene_index:
			1: start_win_cut_scene_two()

func fade_in():
	transition_animator.play("Fade_In")

func fade_out():
	transition_animator.play("Fade_Out")

func move_player_off_screen():
	snowie.global_position += Vector2(0, 1000)

func register_signals():
	GlobalClickEvents.connect("cut_scene_dialogue_block_ended", self, "start_next_dialogue")

func _on_Skip_Button_button_up():
	turn_off_skip_button_visibility()
	skip_button_text_animator.play("Pressed")
	skip_cut_scene()

func turn_off_skip_button_visibility():
	skip_button_BG.visible = false
	skip_button.visible = false
