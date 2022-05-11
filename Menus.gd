extends CanvasLayer

onready var game_over_screen = get_node("Game Over Menu")
onready var win_screen = get_node("Win Menu")

func show_game_over_screen():
	game_over_screen.appear()

func hide_game_over_screen():
	game_over_screen.disappear()

func show_win_screen():
	win_screen.appear()

func hide_win_screen():
	win_screen.disappear()

func _on_Restart_button_up():
	MainGameEvents.emit_signal("restart_game_initiated")
	hide_game_over_screen()
	hide_win_screen()
