extends Sprite

onready var anim_player = get_node("AnimationPlayer")

func _ready():
	play_idle()
	randomize_color()

func play_jumping_happy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_speed = rng.randf_range(0.9, 1.1)
	anim_player.playback_speed = random_speed
	anim_player.play("Jumping Happy")

func play_idle():
	anim_player.play("Idle")

func randomize_color():
	randomize()
	var r = rand_range(0, 1)
	var g = rand_range(0, 1)
	var b = rand_range(0, 1)
	material.set_shader_param("origin", Color("e57373"))
	material.set_shader_param("new", Color(r, g, b, 1))
