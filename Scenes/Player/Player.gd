extends CharacterBody3D

@onready var ennemyMusicAudioPlayer = $AudioRotationNode/AudioStreamPlayer3D
@onready var insideAmbiantAudioPlayer = $InsideAmbiantAudioPlayer
@onready var outsideAmbiantAudioPlayer = $OutsideAmbiantAudioPlayer
@onready var movementAudioPlayer = $MovementAudioPlayer
@onready var stamina_bar = $Camera/PlayerUI/StaminaBar
var SPEED = 5.0
const JUMP_VELOCITY = 4
var mouseSensibility = GlobalVariables.mouse_sensitivity
var mouse_relative_x = 0
var mouse_relative_y = 0
var ennemies_present = false
var ennemies_chasing_player = 0
var player_caught = false
var hidden = false
var has_key = false

var STAMINA = 10
var MAX_STAMINA = 10
var crouching = false
var sprinting = false
var tired = false
var walk_sound = preload("res://Assets/Sounds/walking.mp3")
var run_sound = preload("res://Assets/Sounds/running.mp3")


@onready var donut_eaten = 0
signal interact

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	#Captures mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	stamina_bar.set_value(MAX_STAMINA)
	if get_tree().current_scene.name == "WinWorld":
		$Camera/PlayerUI.visible = false

func _input(event):
	mouseSensibility = 1200 / GlobalVariables.mouse_sensitivity
	if event is InputEventMouseMotion and not get_tree().paused:
		rotation.y -= event.relative.x / mouseSensibility
		$Camera.rotation.x -= event.relative.y / mouseSensibility
		$Camera.rotation.x = clamp($Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
	if event.is_action_pressed("interact"):
		emit_signal("interact");
	if event.is_action_pressed("menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Camera/menuFilter.visible = true
		get_tree().paused = true
		
func _physics_process(delta):
	if get_tree().paused:
		movementAudioPlayer.stop()
	if not get_tree().paused:
		move_and_slide()
		stamina_bar.set_value(STAMINA)
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Jump
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Crouch
		if Input.is_action_just_pressed("crouch") and is_on_floor():
			if not crouching :
				crouching = true
				$AnimationPlayer.play("crouch")
			elif not hidden:
				crouching = false
				$AnimationPlayer.play_backwards("crouch")
		# Stamina
		if STAMINA > 0 and Input.is_action_pressed('sprint') and not tired and not crouching:
			SPEED = 12
			sprinting = true

		else:
			if crouching:
				SPEED = 4
			else:
				SPEED = 7
				sprinting = false
		if STAMINA < 0:
			SPEED = 4
			tired = true
		if tired and STAMINA > MAX_STAMINA/2:
			tired = false
		if STAMINA < MAX_STAMINA:
			STAMINA+=(delta/2)
		# Movement
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if sprinting:
				STAMINA-=(delta*1.5)
			if crouching or not is_on_floor():
				movementAudioPlayer.stop()
			elif sprinting and movementAudioPlayer.get_stream()!=run_sound:
				movementAudioPlayer.set_stream(run_sound)
			elif not crouching and not sprinting and movementAudioPlayer.get_stream()!=walk_sound :
				movementAudioPlayer.set_stream(walk_sound)
			if not movementAudioPlayer.playing and not crouching and is_on_floor():
				movementAudioPlayer.play()
		else:
			movementAudioPlayer.stop()
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		# Scary Music player
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
	if $"Camera/PlayerUI/DonutUi".visible==false:
		$"Camera/PlayerUI/DonutUi".visible=true
	donut_eaten+=1
	$"Camera/PlayerUI/DonutUi/Donut amount".set_text("x "+str(donut_eaten))
	if donut_eaten==10:
		get_tree().change_scene_to_file("res://Levels/win_level/win_level.tscn")

func increment_ennemies_chasing_player():
	ennemies_chasing_player += 1
	
func decrement_ennemies_chasing_player():
	ennemies_chasing_player -= 1

func hide_player():
	hidden = true
	
func unhide_player():
	hidden = false

func toggle_inside_ambiant_player():
	if insideAmbiantAudioPlayer.playing:
		insideAmbiantAudioPlayer.stop()
	else:
		insideAmbiantAudioPlayer.play()

func toggle_outside_ambiant_player():
	if outsideAmbiantAudioPlayer.playing:
		outsideAmbiantAudioPlayer.stop()
	else:
		outsideAmbiantAudioPlayer.play()

func set_inside_ambiant_volume(volume):
	insideAmbiantAudioPlayer.set_volume_db(volume)
	
func set_outside_ambiant_volume(volume):
	outsideAmbiantAudioPlayer.set_volume_db(volume)
	
func add_door_key():
	has_key=true
