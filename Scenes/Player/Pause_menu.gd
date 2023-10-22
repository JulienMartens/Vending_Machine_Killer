extends ColorRect

@onready var slider = $controlFilter/VBoxContainer/HBoxContainer/HSlider
@onready var sensitivityText = $controlFilter/VBoxContainer/HBoxContainer/sensitivity_value

func _on_resume_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible = false

func _on_quit_button_pressed():
	get_tree().quit()


func _on_controls_button_pressed():
	var interact_key = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
	var sprint_key = OS.get_keycode_string(InputMap.action_get_events("sprint")[0].get_physical_keycode_with_modifiers())
	var crouch_key = OS.get_keycode_string(InputMap.action_get_events("crouch")[0].get_physical_keycode_with_modifiers())
	$controlFilter.visible = true
	$controlFilter/VBoxContainer/controls.set_text("[" + interact_key+ "] "+tr("menu_interact")+"\n[" + sprint_key+ "] "+tr("menu_sprint")+"\n[" + crouch_key+ "] "+tr("menu_crouch")+"\n"+tr("menu_jump"))
	sensitivityText.set_text(str(GlobalVariables.mouse_sensitivity))
	slider.set_value_no_signal(GlobalVariables.mouse_sensitivity)
	
func _on_exit_controls_pressed():
	$controlFilter.visible = false


func _on_h_slider_value_changed(value):
	GlobalVariables.mouse_sensitivity = slider.value
	sensitivityText.text = str(slider.value)


func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/main.tscn")

