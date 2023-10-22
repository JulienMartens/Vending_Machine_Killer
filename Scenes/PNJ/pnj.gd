extends CharacterBody3D
@onready var camera_pnj = $Camera3D
@onready var camera_pnj_dead = $Camera3DDead
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var normalVendingMachine = get_tree().get_root().get_node("World/VendingMachine")
@onready var dialogueBox = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var paperDialogueBox = player.get_node("Camera/VBoxContainer/paperDialogue")
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $Body/AnimationPlayer
@onready var VendingMachine = $evil_vending_machine
@onready var VendingMachine_animation_player = $evil_vending_machine/AnimationPlayer
var triggered_state = 0
const SPEED = 8

func _ready():
	player.interact.connect(interact)

func interact():
	if triggered_state==10:
		get_tree().paused = false
		player.get_node("Camera/messageFromBro").visible = false
		paperDialogueBox.text = ""
	if triggered_state in [1,4,10]:
		player.axis_lock_linear_x = false
		player.axis_lock_linear_y = false
		player.axis_lock_linear_z = false
		player.get_node("Camera").current = true
		dialogueBox.text = ""
		triggered_state += 1

func give_back_camera(current_state, timeout=5):
	await get_tree().create_timer(timeout).timeout
	if player.get_node("Camera").current == false and current_state==triggered_state:
		player.axis_lock_linear_x = false
		player.axis_lock_linear_y = false
		player.axis_lock_linear_z = false
		player.get_node("Camera").current = true
		dialogueBox.text = ""
		triggered_state += 1
	
func take_camera(camera="standard"):
	player.axis_lock_linear_x = true
	player.axis_lock_linear_y = true
	player.axis_lock_linear_z = true
	if camera=="standard":
		camera_pnj.current = true
	elif camera=="dead":
		camera_pnj_dead.current = true
	elif camera=="kill":
		$Camera3DAnim.current = true

func _process(_delta):
	if triggered_state in [0,3,4]:
		look_at(player.global_transform.origin)
	if triggered_state == 2 and not get_tree().paused:
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
			triggered_state=7
			death_animation()

func _on_area_3d_body_entered(body):
	if body.name=="Player" and not triggered_state:
		take_camera()
		dialogueBox.text = tr("pnj_greet")
		triggered_state = 1
		give_back_camera(triggered_state,8)
	if body.name=="Player" and triggered_state == 3:
		take_camera()
		dialogueBox.text = tr("pnj_poor")
		get_tree().get_root().get_node("World/Coin").visible = true
		triggered_state = 4
		give_back_camera(triggered_state,10)
	if body.name=="Player" and triggered_state == 8:
		get_tree().paused = true
		player.visible = false
		var camera="dead"
		take_camera(camera)
		dialogueBox.text =  tr("pnj_dead")
		get_tree().get_root().get_node("World/Donuts").visible = true
		await get_tree().create_timer(5).timeout
		dialogueBox.text =  tr("pnj_find_paper")
		triggered_state = 9
	if triggered_state == 9:
		triggered_state=10
		await get_tree().create_timer(5).timeout
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		dialogueBox.text = ""
		paperDialogueBox.text = ("[" + key_name+ "]\n"+tr("exit_paper"))
		player.get_node("Camera/messageFromBro").visible = true
		player.visible = true

func death_animation():
	self.transform.origin = normalVendingMachine.transform.origin +Vector3(0,0,2)
	self.look_at(normalVendingMachine.transform.origin)
	self.transform.origin += Vector3(0,-1.3,0)
	normalVendingMachine.queue_free()
	VendingMachine.visible = true
	var camera="kill"
	take_camera(camera)
	dialogueBox.text = tr("pnj_wait")
	await get_tree().create_timer(5).timeout
	dialogueBox.text = tr("pnj_steal")
	await get_tree().create_timer(8).timeout
	dialogueBox.text = ""
	VendingMachine_animation_player.play("eyes out")
	$evil_vending_machine/ShortScaryPlayer.play()
	await get_tree().create_timer(2).timeout
	$evil_vending_machine/KillMusicPlayer.play()
	VendingMachine_animation_player.play("kill")
	await get_tree().create_timer(0.6).timeout
	animation_player.play("Dying")
	await give_back_camera(triggered_state,2.3)
	VendingMachine.visible = false
	spawn_first_machine()
	GlobalVariables.retry = true

func spawn_first_machine():
	var evil_vending_machine = ResourceLoader.load_threaded_get("res://Scenes/evil_vending_machine/evil_vending_machine.tscn").instantiate()
	evil_vending_machine.position = self.global_transform.origin+Vector3(0,0,5)
	get_tree().get_root().get_node("World").add_child(evil_vending_machine)

func set_triggered_state(value:int):
	triggered_state=value
