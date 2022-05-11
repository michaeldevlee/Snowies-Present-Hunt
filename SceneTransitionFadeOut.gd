extends ColorRect

onready var animPlayer = get_node("AnimationPlayer")

func _ready():
	animPlayer.play("Fade Out")

func fade_in():
	animPlayer.play_backwards("Fade Out")

func fade_out():
	animPlayer.play("Fade Out")
