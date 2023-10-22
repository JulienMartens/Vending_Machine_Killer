extends RigidBody3D

@onready var player = get_tree().get_root().get_node(get_tree().current_scene.name+"/Player")


func _on_area_3d_body_entered(body):
	if body == player and player.donut_eaten==10:
		get_tree().change_scene_to_file("res://Levels/win_level/win_level.tscn")
