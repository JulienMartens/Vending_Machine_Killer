class_name Interactable
extends StaticBody3D

@onready var prompt_action = "interact"
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var player_close = false
var eaten = false
@onready var donuts = get_tree().get_root().get_node("World/Donuts")
var rand = RandomNumberGenerator.new()

func _ready():
	player.interact.connect(interact)

func interact():
	if player_close and donuts.visible :
		var evil_vending_machine = load("res://Scenes/evil_vending_machine/evil_vending_machine.tscn").instantiate()
		evil_vending_machine.position.z = rand.randf_range(-49,49)
		evil_vending_machine.position.x = rand.randf_range(-49,49)
		get_tree().get_root().get_node("World").add_child(evil_vending_machine)
		dialogue.text = ""
		player.increment_donut()
		eaten = true
		queue_free()


func _on_area_3d_body_entered(body):
	if body == player and donuts.visible :
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		dialogue.text = "Manger le donut sucré au sucre"+"\n[" + key_name+ "]"
		player_close = true
		$highlight.visible = true


func _on_area_3d_body_exited(body):
	if body == player and donuts.visible and not eaten :
		dialogue.text = ""
		player_close = false
		$highlight.visible = false
