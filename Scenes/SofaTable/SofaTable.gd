extends Node3D
@onready var player = get_tree().get_root().get_node("World/Player")


func _on_area_3d_body_entered(body):
	if body.name=="Player":
		player.hide_player()


func _on_area_3d_body_exited(body):
	if body.name=="Player":
		player.unhide_player()
