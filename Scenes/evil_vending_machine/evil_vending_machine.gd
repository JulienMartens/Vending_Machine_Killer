extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_root().get_node("World").get_node("Player")
const SPEED = 7.5

func _ready():
		add_to_group("ennemies")
		
func _physics_process(delta):
	var current_location = global_transform.origin
	var target_location = player.global_transform.origin
	nav_agent.set_target_location(target_location)
	var next_location = nav_agent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity,0.25)
	look_at(target_location)
	move_and_slide()
	if player.ennemies_present==false:
		player.ennemies_present=true


func _on_area_3d_body_entered(body):
	if body.name=="Player":
		player.look_at(global_transform.origin)
		var label = player.get_node("Camera").get_node("UI").get_node("Label")
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		$Camera3D.current = true
		player.visible = false
		label.text = "t mor sale merd"