extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var target_location
const SPEED = 4.5

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * SPEED

	velocity = velocity.move_toward(new_velocity,0.25)
	look_at(target_location)
	move_and_slide()
	
func update_target_location(player_location):
	target_location = player_location
	nav_agent.set_target_location(target_location)
