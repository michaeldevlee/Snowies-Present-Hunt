extends Node2D

onready var flash = get_node("Flash")

func play_feedback():
	flash.visible = !flash.visible
