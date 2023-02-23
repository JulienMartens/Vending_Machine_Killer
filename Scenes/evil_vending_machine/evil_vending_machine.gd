extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var timer = get_node("Timer")
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var target_location = player.global_transform.origin
@onready var patrol_points = get_tree().get_nodes_in_group("patrol_waypoints_group")
var machineStatesEnum = {chasing_player="chasing_player",looking_around="looking_around",patrolling="patrolling",stopped="stopped"}
var currentMachineState = machineStatesEnum.looking_around
var look_around_animation_played = true
const CHASING_SPEED = 7.5
const SPEED = 4

func _ready():
		add_to_group("ennemies")
		
func _physics_process(_delta):
	var current_speed = SPEED
	if not player.player_caught:
		if currentMachineState==machineStatesEnum.chasing_player:
			if player.ennemies_present==false:
				player.ennemies_present=true
			target_location = player.global_transform.origin
			$AnimationPlayer.play("chase")
			current_speed = CHASING_SPEED
		elif currentMachineState==machineStatesEnum.looking_around and look_around_animation_played:
			randomize()
			target_location = patrol_points[randi_range(1,patrol_points.size()-1)].global_transform.origin
			current_speed = SPEED
			currentMachineState = machineStatesEnum.patrolling
			look_around_animation_played = false
		nav_agent.set_target_position(target_location)
		var current_position : Vector3 = global_transform.origin
		var next_path_position : Vector3 = nav_agent.get_next_path_position()
		var new_velocity : Vector3 = next_path_position - current_position
		new_velocity = new_velocity.normalized() * current_speed
		set_velocity(new_velocity)
		if currentMachineState==machineStatesEnum.chasing_player or nav_agent.distance_to_target()>3:
			look_at(target_location)
		move_and_slide()


func _on_detection_area_body_entered(body):
	if body.name=="Player" and not player.player_caught:
		if not currentMachineState==machineStatesEnum.chasing_player:
			player.increment_ennemies_chasing_player()
			currentMachineState=machineStatesEnum.chasing_player
		else:
			timer.stop()


func _on_detection_area_body_exited(body):
	if body.name=="Player" and not player.player_caught:
		timer.start(10)
	
func _on_timer_timeout():
	player.decrement_ennemies_chasing_player()
	currentMachineState = machineStatesEnum.stopped



func _on_death_area_body_entered(body):
	if body.name=="Player":
		player.player_caught = true
		currentMachineState = machineStatesEnum.stopped
		player.look_at(global_transform.origin)
		var label = player.get_node("Camera/UI/HBoxContainer/Dialogue")
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		$Camera3D.current = true
		$AnimationPlayer.play("win")
		player.ennemies_present=false
		player.get_node("AudioRotationNode/AudioStreamPlayer3D").stop()
		$AudioStreamPlayer.play()
		player.visible = false
		label.text = "t mor sale merd"


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "look_around":
		look_around_animation_played = true



func _on_navigation_agent_3d_navigation_finished():
	if currentMachineState==machineStatesEnum.patrolling:
		currentMachineState=machineStatesEnum.looking_around
		$AnimationPlayer.play("look_around")
