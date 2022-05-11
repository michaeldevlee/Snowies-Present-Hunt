extends Node2D

onready var present_spawn_area = get_node("Present Spawn Area")

var present = preload("res://Background/Present/Present.tscn")

func create_present():
	randomize()
	var random_x_pos = rand_range(0, present_spawn_area.rect_size.x)
	var random_y_pos = rand_range(0, present_spawn_area.rect_size.y)
	
	var new_present = present.instance()
	add_child(new_present)
	new_present.position.x = random_x_pos
	new_present.position.y = random_y_pos
