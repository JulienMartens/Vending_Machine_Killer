extends Node3D

@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
var is_on_screen = false

func _ready():
	player.interact.connect(interact)

func interact():
	if is_on_screen :
		player.add_door_key()
		queue_free()


func _on_area_3d_body_entered(body):
	if body == player:
		is_on_screen = true
		$Cylinder/highlight.visible = true
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		dialogue.set_text("[" + key_name+ "]\n"+tr("key_grab"))


func _on_area_3d_body_exited(body):
	if body == player:
		is_on_screen = false
		$Cylinder/highlight.visible = false
		dialogue.text = ""
