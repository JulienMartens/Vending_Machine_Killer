extends Node3D

@onready var player = $Player
@onready var pnj = $PNJ
@onready var normalVendingMachine = $VendingMachine
func _ready():
	if GlobalVariables.retry:
		pnj.set_triggered_state(10)
		pnj.transform.origin = normalVendingMachine.transform.origin +Vector3(0,0,2)
		pnj.look_at(normalVendingMachine.transform.origin)
		pnj.transform.origin += Vector3(0,-1.3,0)
		normalVendingMachine.queue_free()
		pnj.get_node("Body/AnimationPlayer").play("Dying")
		pnj.spawn_first_machine()
		player.transform.origin =  Vector3(-13,0.5,12)
		player.look_at(pnj.transform.origin)
		get_node("Donuts").visible = true

func _physics_process(_delta):
	get_tree().call_group("ennemies","update_target_location", player.global_transform.origin)

