extends CharacterBody3D

@onready var holdPosition = $Camera/HoldPosition
@onready var ennemyMusicAudioPlayer = $AudioRotationNode/AudioStreamPlayer3D
const SPEED = 11.0
const JUMP_VELOCITY = 4.5
var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
var ennemies_present = false
var ennemies_chasing_player = 0
var player_caught = false
@onready var donut_eaten = 0
signal interact

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	#Captures mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		$Camera.rotation.x -= event.relative.y / mouseSensibility
		$Camera.rotation.x = clamp($Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
	if event.is_action_pressed("interact"):
		emit_signal("interact");
		
func _physics_process(delta):
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
# Push rigidbodies on collide	
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		if collision.get_collider() is RigidBody3D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 0.3)
			collision.get_collider().apply_impulse(-collision.get_normal() * 0.01, collision.get_position())

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if ennemies_present and ennemies_chasing_player:
		var ennemies = get_tree().get_nodes_in_group("ennemies")
		var closest_ennemy_position = ennemies[0].global_transform.origin
		var closest_ennemy_distance = global_transform.origin.distance_to(closest_ennemy_position)
		for ennemy in ennemies:
			var current_ennemy_distance = global_transform.origin.distance_to(ennemy.global_transform.origin)
			if closest_ennemy_distance > current_ennemy_distance:
				closest_ennemy_position = ennemy.global_transform.origin
				closest_ennemy_distance = current_ennemy_distance
		if not ennemyMusicAudioPlayer.playing:
			ennemyMusicAudioPlayer.play()
		ennemyMusicAudioPlayer.volume_db=(-closest_ennemy_distance)
		$AudioRotationNode.look_at(closest_ennemy_position)
	else:
		ennemyMusicAudioPlayer.stop()

func increment_donut():
	donut_eaten+=1
	if donut_eaten==10:
		$Camera/UI/HBoxContainer/Dialogue.text = "BRAVO TU AS MANGÉ TOUS LES DONUTS WOW T'ES CHAUD !! \n Tu peux demander au dev d'ajouter ton nom a la liste des gens qui ont réussi, bien joué : \n Maxime Martens, le fabriquant de distributeurs automatiques"
		get_tree().paused = true

func increment_ennemies_chasing_player():
	ennemies_chasing_player += 1
	
func decrement_ennemies_chasing_player():
	ennemies_chasing_player -= 1
