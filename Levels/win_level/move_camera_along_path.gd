extends Path3D

var move_speed = 23.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PathFollow3D.progress += move_speed * delta


func _on_timer_timeout():
	move_speed = 2.5
