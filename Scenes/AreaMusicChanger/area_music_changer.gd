extends Node3D

@onready var player = get_tree().get_root().get_node(get_tree().current_scene.name+"/Player")
var is_player_going_outside = true
var in_outside_area = false
var in_inside_area = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var distance_from_center = player.global_transform.origin.distance_to(self.global_transform.origin)
		if in_inside_area:
			player.set_inside_ambiant_volume(distance_from_center-9)
		if in_outside_area:
			player.set_outside_ambiant_volume(distance_from_center)
			
func _on_inner_area_body_entered(body):
	if body == player :
		in_inside_area = true
		if in_outside_area:
			player.toggle_inside_ambiant_player()
			
func _on_inner_area_body_exited(body):
	if body == player :
		in_inside_area = false
		if in_outside_area:
			player.toggle_inside_ambiant_player()
		
func _on_outer_area_body_entered(body):
	if body == player :
		in_outside_area = true
		if in_inside_area:
			player.toggle_outside_ambiant_player()
			
func _on_outer_area_body_exited(body):
	if body == player :
		in_outside_area = false
		if in_inside_area:
			player.toggle_outside_ambiant_player()
