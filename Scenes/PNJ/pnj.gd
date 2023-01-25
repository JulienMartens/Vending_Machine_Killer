extends CharacterBody3D
@onready var camera_pnj = $Camera3D
@onready var player = get_tree().get_root().get_node("World").get_node("Player")
@onready var triggered_state = 0

func _on_area_3d_body_entered(body):
	if body.name=="Player" and not triggered_state:
		player.look_at(global_transform.origin)
		var label = player.get_node("Camera/UI/HBoxContainer/Dialogue")
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		label.text = "Uesh mec c'est chaud ce qu'il se passe ici, il y a des distributeurs automatiques qui fument tout le monde ! \n Il faut que tu trouves tous les donuts et que tu les grailles ou t'es mort poto... y'en a genre 10, aller bonne chance"
		triggered_state = 1

func _process(_delta):
	look_at(player.global_transform.origin)
	if Input.is_action_just_pressed("interact") and triggered_state == 1:
		player.axis_lock_linear_x = false
		player.axis_lock_linear_y = false
		player.axis_lock_linear_z = false
		player.get_node("Camera").current = true
		var label = player.get_node("Camera/UI/HBoxContainer/Dialogue")
		label.text = ""
		triggered_state = 2
