extends CharacterBody3D
@onready var camera_pnj = $Camera3D
@onready var camera_pnj_dead = $Camera3DDead
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogueBox = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $Body/AnimationPlayer
var triggered_state = 0
const SPEED = 8

func _ready():
	player.interact.connect(interact)
	
func interact():
	if triggered_state in [1,4,8]:
		player.axis_lock_linear_x = false
		player.axis_lock_linear_y = false
		player.axis_lock_linear_z = false
		player.get_node("Camera").current = true
		dialogueBox.text = ""
		triggered_state += 1

func _process(_delta):
	if triggered_state in [0,3,4]:
		look_at(player.global_transform.origin)
	if triggered_state == 2:
		var target_location = get_tree().get_root().get_node("World").get_node("VendingMachine").global_transform.origin
		nav_agent.set_target_position(target_location)
		var current_position : Vector3 = global_transform.origin
		var next_path_position : Vector3 = nav_agent.get_next_path_position()
		var new_velocity : Vector3 = next_path_position - current_position
		new_velocity = new_velocity.normalized() * SPEED
		set_velocity(new_velocity)
		look_at(target_location)
		move_and_slide()
		animation_player.play("Walking in place")
		if nav_agent.distance_to_target()<5:
			animation_player.play("Idle")
			triggered_state = 3
	if triggered_state == 6:
			animation_player.play("Dying")
			triggered_state=7
				
func _on_area_3d_body_entered(body):
	if body.name=="Player" and not triggered_state:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		dialogueBox.text = tr("pnj_greet")
		triggered_state = 1
	if body.name=="Player" and triggered_state == 3:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		dialogueBox.text = tr("pnj_poor")
		get_tree().get_root().get_node("World/Coin").visible = true
		triggered_state = 4
	if body.name=="Player" and triggered_state == 7:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj_dead.current = true
		dialogueBox.text =  tr("pnj_dead")
		get_tree().get_root().get_node("World/Donuts").visible = true
		triggered_state = 8
