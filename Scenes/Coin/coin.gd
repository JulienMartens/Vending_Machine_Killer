extends MeshInstance3D

@onready var prompt_action = "interact"
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var pnj = get_tree().get_root().get_node("World/PNJ")
@onready var player_close = false
var taken = false
func _ready():
	player.interact.connect(interact)
	$AnimationPlayer.play("rotate")
	
func interact():
	if player_close and visible :
		taken = true
		dialogue.text = ""
		pnj.triggered_state = 6
		queue_free()


func _on_area_3d_body_entered(body):
	if body == player and visible:
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		dialogue.text = "Attraper la pièce de 1€"+"\n[" + key_name+ "]"
		player_close = true
		$highlight.visible = true


func _on_area_3d_body_exited(body):
	if body == player and visible and not taken :
		dialogue.text = ""
		player_close = false
		$highlight.visible = false
