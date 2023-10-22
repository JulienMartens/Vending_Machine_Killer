extends Path3D

@onready var player = get_tree().get_root().get_node(get_tree().current_scene.name+"/Player")
var move_speed = 0

func _physics_process(delta):
	$PathFollow3D.progress += move_speed * delta
	if self.visible == false and player.has_key:
		self.visible = true
	if $PathFollow3D.progress_ratio == 1:
		queue_free()
		
func _on_area_3d_body_entered(body):
	if self.visible:
		$HouseJumpscare.play()
		move_speed = 10
