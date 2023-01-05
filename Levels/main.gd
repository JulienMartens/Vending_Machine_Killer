extends Node3D

@onready var player = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_tree().call_group("ennemies","update_target_location", player.global_transform.origin)
