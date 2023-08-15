extends Node3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Camera3D/VBoxContainer2/FrButton.set_pressed_no_signal(true)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_fr_button_pressed():
	TranslationServer.set_locale('fr')



func _on_en_button_pressed():
	TranslationServer.set_locale('en')



func _on_es_button_pressed():
	TranslationServer.set_locale('es')
