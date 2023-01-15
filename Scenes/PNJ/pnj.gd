extends CharacterBody3D
@onready var camera_pnj = $Camera3D
@onready var player = get_tree().get_root().get_node("World").get_node("Player")
@onready var triggered_state = 0

func _on_area_3d_body_entered(body):
	if body.name=="Player" and not triggered_state:
		player.look_at(global_transform.origin)
		var label = player.get_node("Camera").get_node("UI").get_node("Label")
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		label.text = "Uesh il faut pas trainer dans la forêt comme ça...mange au moins un donut"
		triggered_state = 1

func _process(delta):
	look_at(player.global_transform.origin)
	if Input.is_action_just_pressed("interact") and triggered_state == 1:
		player.axis_lock_linear_x = false
		player.axis_lock_linear_y = false
		player.axis_lock_linear_z = false
		player.get_node("Camera").current = true
		var label = player.get_node("Camera").get_node("UI").get_node("Label")
		label.text = ""
		triggered_state = 2
