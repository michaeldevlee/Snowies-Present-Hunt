extends Node2D

var snowie_friends : Array = []

func _ready():
	snowie_friends = get_children()

func play_win_animation():
	for x in snowie_friends.size():
		var friend : Sprite = snowie_friends[x]
		if friend.is_in_group("Friend"):
			friend.play_jumping_happy()

func play_lose_animation():
	pass
