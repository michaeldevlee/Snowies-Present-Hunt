extends Node2D

onready var background_music_player = get_node("Background Music Player")
onready var background_SFX_player = get_node("Background SFX Player")
onready var interact_SFX_player = get_node("Interact SFX Player")
onready var event_SFX_player = get_node("Event SFX Player")
var music = preload("res://Audio/Music/Music.tres")
var sfx = preload("res://Audio/Music/SFX.tres")
var max_volume = 0
var min_volume = 80

func _ready():
	pass

func play_music(stream : AudioStream):
	background_music_player.set_stream(stream)
	background_music_player.play()

func play_bg_SFX (stream : AudioStream):
	background_SFX_player.set_stream(stream)
	background_SFX_player.play()

func play_interact_SFX (stream : AudioStream):
	interact_SFX_player.set_stream(stream)
	interact_SFX_player.play()

func play_event_SFX (stream : AudioStream):
	event_SFX_player.set_stream(stream)
	event_SFX_player.play()

func adjust_SFX_volume(value):
	
	var volume = normalize_volume_value(value)
	background_SFX_player.set_volume_db(volume)
	event_SFX_player.set_volume_db(volume)
	interact_SFX_player.set_volume_db(volume)

func adjust_music_volume(value):
	var volume = normalize_volume_value(value)
	background_music_player.set_volume_db(volume)
	
func normalize_volume_value(value):
	var step = min_volume/100.0
	var volume = step * value - abs(min_volume)
	print(volume)
	return volume
