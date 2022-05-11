extends Node2D

onready var sprite = get_node("Sprite Sheet")

var texture_sets : Array = [
]

func _ready():
	set_picture_texture()
	print(texture_sets)

func set_picture_texture():
	var rng = RandomNumberGenerator.new()
	var h_frames = sprite.get_hframes()
	var v_frames = sprite.get_vframes()
	rng.randomize()
	var random_frame = rng.randi_range(0, (h_frames * v_frames)-1)
	print(random_frame)
	
	if v_frames > 1 || h_frames > 1:
		sprite.set_frame(random_frame)
	else:
		print("texture does not exist")
	
