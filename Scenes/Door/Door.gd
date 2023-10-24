extends Node3D

@onready var player = get_tree().get_root().get_node(get_tree().current_scene.name+"/Player")
@onready var dialogue = player.get_node("Camera/UI/HBoxContainer/Dialogue")
@onready var timer = get_node("Timer")
var playerPosition = "far"
var vendingMachinePosition = "far"
var visibleOnScreen = true
var doorPositionsEnum = {Closed="Closed",OpenIn="OpenIn",OpenOut="OpenOut",Broken="Broken"}
var currentDoorPosition = doorPositionsEnum.Closed

func _ready():
	player.interact.connect(interact)

func _on_visible_on_screen_notifier_3d_screen_entered():
	visibleOnScreen = true
func _on_visible_on_screen_notifier_3d_screen_exited():
	visibleOnScreen = false
	if playerPosition != "far":
		dialogue.text = ""

func _on_back_area_body_entered(body):
	if body == player :
		playerPosition = "back"
	if "evil_vending_machine" in body.name and currentDoorPosition == doorPositionsEnum.Closed:
		vendingMachinePosition = "back"
		$AnimationPlayer.play("BreakOut")
		$HitAudioPlayer.play()
		timer.start()
		
func _on_back_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""
	if "evil_vending_machine" in body.name :
		vendingMachinePosition = "far"
		$HitAudioPlayer.stop()
		timer.stop()

func _on_front_area_body_entered(body):
	if body == player :
		playerPosition = "front"
	if "evil_vending_machine" in body.name and currentDoorPosition == doorPositionsEnum.Closed:
		$AnimationPlayer.play("BreakIn")
		vendingMachinePosition = "front"
		$HitAudioPlayer.play()
		timer.start()
func _on_front_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""
	if "evil_vending_machine" in body.name :
		vendingMachinePosition = "far"
		$HitAudioPlayer.stop()
		timer.stop()
		

func _on_timer_timeout():
	if vendingMachinePosition == "front":
		$AnimationPlayer.play("BrokenIn")
		$BreakAudioPlayer.play()
	elif vendingMachinePosition == "back":
		$AnimationPlayer.play("BrokenOut")
		$BreakAudioPlayer.play()
	currentDoorPosition = doorPositionsEnum.Broken
	$StaticBody3D.queue_free()

func interact():
	if visibleOnScreen and not playerPosition=="far":
		if currentDoorPosition == doorPositionsEnum.Closed:
			if playerPosition == "front":
				$AnimationPlayer.play(doorPositionsEnum.OpenIn)
				$DoorOpenPlayer.play()
				currentDoorPosition = doorPositionsEnum.OpenIn
			elif playerPosition == "back":
				$AnimationPlayer.play(doorPositionsEnum.OpenOut)
				$DoorOpenPlayer.play()
				currentDoorPosition = doorPositionsEnum.OpenOut
		elif currentDoorPosition == doorPositionsEnum.OpenIn:
			$AnimationPlayer.play_backwards(doorPositionsEnum.OpenIn)
			currentDoorPosition = doorPositionsEnum.Closed
			$DoorClosePlayer.play()
		elif currentDoorPosition == doorPositionsEnum.OpenOut:
			$AnimationPlayer.play_backwards(doorPositionsEnum.OpenOut)
			$DoorClosePlayer.play()
			currentDoorPosition = doorPositionsEnum.Closed

func _process(_delta):
	if visibleOnScreen and not playerPosition=="far":
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		if currentDoorPosition == doorPositionsEnum.Closed:
			dialogue.set_text("[" + key_name+ "]\n"+tr("door_open"))
		elif currentDoorPosition in [doorPositionsEnum.OpenIn,doorPositionsEnum.OpenOut]:
			dialogue.set_text("[" + key_name+ "]\n"+tr("door_close"))
