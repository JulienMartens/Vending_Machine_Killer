extends ColorRect

func _on_resume_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible = false

func _on_quit_button_pressed():
	get_tree().quit()
