class_name Interactable
extends StaticBody3D

@export var prompt_message = "Manger le donut sucré au sucre"
@export var prompt_action = "interact"
var rand = RandomNumberGenerator.new()


func get_prompt():

	var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
	return prompt_message + "\n[" + key_name+ "]"

func interact():
	var evil_vending_machine = load("res://Scenes/evil_vending_machine/evil_vending_machine.tscn").instantiate()
	evil_vending_machine.position.z = rand.randf_range(-49,49)
	evil_vending_machine.position.x = rand.randf_range(-49,49)
	get_tree().get_root().get_node("World").add_child(evil_vending_machine)
	queue_free()
