extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_root().get_node("World/Player")
const SPEED = 7.5

func _ready():
		add_to_group("ennemies")
		
func _physics_process(_delta):
	if not player.player_caught:
		var current_location = global_transform.origin
		var target_location = player.global_transform.origin
		nav_agent.set_target_location(target_location)
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = velocity.move_toward(new_velocity,0.25)
		look_at(target_location)
		move_and_slide()
		$AnimationPlayer.play("walk")
		if player.ennemies_present==false:
			player.ennemies_present=true

func _on_area_3d_body_entered(body):
	if body.name=="Player":
		player.player_caught = true
		player.look_at(global_transform.origin)
		var label = player.get_node("Camera/UI/HBoxContainer/Dialogue")
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		$Camera3D.current = true
		$AnimationPlayer.play("win")
		player.ennemies_present=false
		player.get_node("AudioStreamPlayer3D").stop()
		$AudioStreamPlayer.play()
		player.visible = false
		label.text = "t mor sale merd"
