class_name Interactable
extends StaticBody3D

@onready var player = get_tree().get_root().get_node(get_tree().current_scene.name+"/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var player_close = false
@onready var donuts = get_tree().get_root().get_node(get_tree().current_scene.name+"/Donuts")
@onready var patrol_points = get_tree().get_nodes_in_group("patrol_waypoints_group")
var eaten = false
var rand = RandomNumberGenerator.new()

func _ready():
	ResourceLoader.load_threaded_request("res://Scenes/evil_vending_machine/evil_vending_machine.tscn")
	player.interact.connect(interact)

func interact():
	if player_close and donuts.visible :
		var evil_vending_machine = ResourceLoader.load_threaded_get("res://Scenes/evil_vending_machine/evil_vending_machine.tscn").instantiate()
		evil_vending_machine.position = patrol_points[randi_range(1,patrol_points.size()-1)].global_transform.origin
		get_tree().get_root().get_node("World").add_child(evil_vending_machine)
		dialogue.text = ""
		player.increment_donut()
		eaten = true
		get_tree().get_root().get_node("World/EatingSoundPlayer").play()
		queue_free()


func _on_area_3d_body_entered(body):
	if body == player and donuts.visible :
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		dialogue.set_text("[" + key_name+ "]\n"+tr("donut_eat"))
		player_close = true
		$SweetenedDonut/highlight.visible = true


func _on_area_3d_body_exited(body):
	if body == player and donuts.visible and not eaten :
		dialogue.text = ""
		player_close = false
		$SweetenedDonut/highlight.visible = false
