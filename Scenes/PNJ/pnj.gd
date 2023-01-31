extends CharacterBody3D
@onready var camera_pnj = $Camera3D
@onready var player = get_tree().get_root().get_node("World/Player")
@onready var dialogueBox = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var nav_agent = $NavigationAgent3D
var triggered_state = 0
const SPEED = 8

func _ready():
	player.interact.connect(interact)
	
func interact():
	if triggered_state in [1,4,7]:
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
		$NavigationAgent3D.set_target_location(target_location)
		var next_location = $NavigationAgent3D.get_next_location()
		var new_velocity = (next_location - global_transform.origin).normalized() * SPEED
		velocity = velocity.move_toward(new_velocity,0.25)
		look_at(target_location)
		move_and_slide()
		$AnimationPlayer.play("walk")
		if $NavigationAgent3D.distance_to_target()<2:
			$AnimationPlayer.play("RESET")
			triggered_state = 3
	if triggered_state == 6:
			$AnimationPlayer.play("dead")
				
func _on_area_3d_body_entered(body):
	if body.name=="Player" and not triggered_state:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		dialogueBox.text = "Wesh poto, bien ou bien ? \n Eh, j'ai un petit creux, viens on va s'acheter des donuts sucrés au sucre, il y a un distributeur juste la"
		triggered_state = 1
	if body.name=="Player" and triggered_state == 3:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		dialogueBox.text = "Wesh en fait j'ai oublié que j'avais pas d'argent car je suis intermittent du spectacle ! \n Tu pourrais regarder si tu trouves une pièce de 1€ quelque part stp ?"
		get_tree().get_root().get_node("World/Coin").visible = true
		triggered_state = 4
	if body.name=="Player" and triggered_state == 6:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		camera_pnj.current = true
		dialogueBox.text = "IL S'EST FAIT FUMER"
		await player.interact
		dialogueBox.text = "Ca craint de fou, c'est pour ca que les loyers sont pas cher par ici"
		await player.interact
		dialogueBox.text = "Le meilleur moyen d'honorer sa mémoire c'est de manger un bon donut, \n c'était sa dernière volonté"
		await player.interact
		dialogueBox.text = "Enfin sa dernière volonté c'était que lui mange un donut mais maintenant c'est chaud"
		get_tree().get_root().get_node("World/Donuts").visible = true
		triggered_state = 7
