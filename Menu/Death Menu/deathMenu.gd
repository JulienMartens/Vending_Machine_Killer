extends Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_button_pressed():
	GlobalVariables.retry = true
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Main Menu/mainMenu.tscn")
