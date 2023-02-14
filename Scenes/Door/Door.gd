extends Node3D

@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
var playerPosition = "far"
var visibleOnScreen = true
var doorPosition = "closed"

func _ready():
	player.interact.connect(interact)

func _on_visible_on_screen_notifier_3d_screen_entered():
	visibleOnScreen = true
func _on_visible_on_screen_notifier_3d_screen_exited():
	visibleOnScreen = false
	dialogue.text = ""

func _on_back_area_body_entered(body):
	if body == player :
		playerPosition = "back"
func _on_back_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""

func _on_front_area_body_entered(body):
	if body == player :
		playerPosition = "front"
func _on_front_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""

func interact():
	if visibleOnScreen and not playerPosition=="far":
		if doorPosition == "closed":
			if playerPosition == "front":
				$AnimationPlayer.play("OpenIn")
				doorPosition = "OpenIn"
			elif playerPosition == "back":
				$AnimationPlayer.play("OpenOut")
				doorPosition = "OpenOut"
		elif doorPosition == "OpenIn":
			$AnimationPlayer.play_backwards("OpenIn")
			doorPosition = "closed"
		elif doorPosition == "OpenOut":
			$AnimationPlayer.play_backwards("OpenOut")
			doorPosition = "closed"

func _process(_delta):
	if visibleOnScreen and not playerPosition=="far":
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		if doorPosition == "closed":
			dialogue.text = "Ouvrir la porte"+"\n[" + key_name+ "]"
		else :
			dialogue.text = "Fermer la porte"+"\n[" + key_name+ "]"
