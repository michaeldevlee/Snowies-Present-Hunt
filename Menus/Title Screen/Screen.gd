extends Node2D

onready var tween = get_node("Tween")
onready var transition = get_node("Transition")
onready var settings_screen = get_node("CanvasLayer/Settings Screen")
onready var settings_animator = get_node("Sprite/AnimationPlayer")
onready var help_screen = get_node("CanvasLayer/Help Screen")
onready var help_animator = get_node("Sign/Sign Animator")

export (String, FILE, "*.tscn") var next_scene 

enum menus {TITLE_SCREEN, SETTINGS, HELP}
var current_menu = menus.TITLE_SCREEN
var ready_to_play : bool = false

func _ready():
	if !tween.is_active():
		tween.interpolate_property(transition, "modulate", Color(0,0,0,1), Color(0,0,0,0), 2 ,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		tween.start()
		yield(tween,"tween_completed")
		ready_to_play = true
		Audio.play_bg_SFX(Audio.sfx.wind_ambience)
		Audio.play_music(Audio.music.title_screen)

func _on_Play_button_up():
	if !tween.is_active() and ready_to_play and current_menu == menus.TITLE_SCREEN:
		tween.interpolate_property(transition, "modulate", Color(0,0,0,0), Color(0,0,0,1), 2 ,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		tween.start()
		Audio.play_interact_SFX(Audio.sfx.gesture_completed)
		Audio.background_music_player.stop()
		yield(tween,"tween_completed")
		get_tree().change_scene(next_scene)
		Audio.background_SFX_player.stop()
		

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and current_menu == menus.TITLE_SCREEN:
			current_menu = menus.SETTINGS
			settings_animator.play("Select")
			Audio.play_event_SFX(Audio.sfx.next_dialogue)
			yield(settings_animator, "animation_finished")
			settings_screen.appear()
	
	if event is InputEventMouseButton:
		if event.button_index == 1 and current_menu == menus.TITLE_SCREEN:
			current_menu = menus.SETTINGS
			settings_animator.play("Select")
			Audio.play_event_SFX(Audio.sfx.next_dialogue)
			yield(settings_animator, "animation_finished")
			settings_screen.appear()


func _on_SFX_Slider_value_changed(value):
	Audio.adjust_SFX_volume(value)

func _on_Music_Slider_value_changed(value):
	Audio.adjust_music_volume(value)

func _on_Sign_Area_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and current_menu == menus.TITLE_SCREEN:
			current_menu = menus.HELP
			help_animator.play("Select")
			Audio.play_event_SFX(Audio.sfx.next_dialogue)
			yield(help_animator, "animation_finished")
			help_screen.appear()
	
	if event is InputEventMouseButton:
		if event.button_index == 1 and current_menu == menus.TITLE_SCREEN:
			current_menu = menus.HELP
			help_animator.play("Select")
			Audio.play_event_SFX(Audio.sfx.next_dialogue)
			yield(help_animator, "animation_finished")
			help_screen.appear()


func _on_Help_Screen_Return_Button_button_up():
	current_menu = menus.TITLE_SCREEN
	help_screen.disappear()


func _on_Settings_Return_Button_button_up():
	current_menu = menus.TITLE_SCREEN
	settings_screen.disappear()
