extends Node3D

@onready var slider = $Camera3D/menuFilter/VBoxContainer/HBoxContainer/HSlider
@onready var sensitivityText = $Camera3D/menuFilter/VBoxContainer/HBoxContainer/sensitivity_value

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Camera3D/HBoxContainer/VBoxContainer2/FrButton.set_pressed_no_signal(true)
	slider.set_value_no_signal(GlobalVariables.mouse_sensitivity)
	sensitivityText.text = str(GlobalVariables.mouse_sensitivity)

func _on_start_button_pressed():
	GlobalVariables.retry=false
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_fr_button_pressed():
	TranslationServer.set_locale('fr')



func _on_en_button_pressed():
	TranslationServer.set_locale('en')



func _on_es_button_pressed():
	TranslationServer.set_locale('es')


func _on_controls_button_pressed():
	var interact_key = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
	var sprint_key = OS.get_keycode_string(InputMap.action_get_events("sprint")[0].get_physical_keycode_with_modifiers())
	var crouch_key = OS.get_keycode_string(InputMap.action_get_events("crouch")[0].get_physical_keycode_with_modifiers())
	$Camera3D/menuFilter.visible = true
	$Camera3D/menuFilter/VBoxContainer/controls.set_text("[" + interact_key+ "] "+tr("menu_interact")+"\n[" + sprint_key+ "] "+tr("menu_sprint")+"\n[" + crouch_key+ "] "+tr("menu_crouch")+"\n"+tr("menu_jump"))


func _on_exit_controls_pressed():
	$Camera3D/menuFilter.visible = false

func _on_h_slider_value_changed(value):
	GlobalVariables.mouse_sensitivity = slider.value
	sensitivityText.text = str(slider.value)

func _on_discord_button_pressed():
	OS.shell_open("https://discord.gg/dNPfAz2r")

func _on_donate_button_pressed():
	OS.shell_open("https://ko-fi.com/streum")
