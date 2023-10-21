extends Path3D

var move_speed = 2.5


func _ready():
	$PathFollow3D/evil_vending_machine/AnimationPlayer.stop()

func _physics_process(delta):
	$PathFollow3D.progress += move_speed * delta
