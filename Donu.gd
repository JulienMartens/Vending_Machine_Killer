class_name Interactable
extends StaticBody3D

@export var prompt_message = "Manger le donut sucré au sucre"
@export var prompt_action = "interact"


func get_prompt():

	var interactInputKey = InputMap.action_get_events("interact")[0]
	var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
	return prompt_message + "\n[" + key_name+ "]"

func interact(body):
	queue_free()
