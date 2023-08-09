extends Node3D

@onready var player = get_tree().get_root().get_node("World/Player")
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
	if body.name == "evil_vending_machine" and currentDoorPosition == doorPositionsEnum.Closed :
		vendingMachinePosition = "back"
		$AnimationPlayer.play("BreakOut")
		timer.start()
func _on_back_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""
	if body.name == "evil_vending_machine" :
		vendingMachinePosition = "far"
		timer.stop()

func _on_front_area_body_entered(body):
	if body == player :
		playerPosition = "front"
	if body.name == "evil_vending_machine" and currentDoorPosition == doorPositionsEnum.Closed :
		$AnimationPlayer.play("BreakIn")
		vendingMachinePosition = "front"
		timer.start()
func _on_front_area_body_exited(body):
	if body == player :
		playerPosition = "far"
		dialogue.text = ""
	if body.name == "evil_vending_machine" :
		vendingMachinePosition = "far"
		timer.stop()
		

func _on_timer_timeout():
	if vendingMachinePosition == "front":
		$AnimationPlayer.play("BrokenIn")
	elif vendingMachinePosition == "back":
		$AnimationPlayer.play("BrokenOut")
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
			await $AnimationPlayer.animation_finished
			$DoorClosePlayer.play()
			currentDoorPosition = doorPositionsEnum.Closed
		elif currentDoorPosition == doorPositionsEnum.OpenOut:
			$AnimationPlayer.play_backwards(doorPositionsEnum.OpenOut)
			await $AnimationPlayer.animation_finished
			$DoorClosePlayer.play()
			currentDoorPosition = doorPositionsEnum.Closed

func _process(_delta):
	if visibleOnScreen and not playerPosition=="far":
		var key_name = OS.get_keycode_string(InputMap.action_get_events("interact")[0].get_physical_keycode_with_modifiers())
		if currentDoorPosition == doorPositionsEnum.Closed:
			dialogue.set_text(tr("door_open")+"\n[" + key_name+ "]")
		elif currentDoorPosition in [doorPositionsEnum.OpenIn,doorPositionsEnum.OpenOut]:
			dialogue.set_text(tr("door_close")+"\n[" + key_name+ "]")
