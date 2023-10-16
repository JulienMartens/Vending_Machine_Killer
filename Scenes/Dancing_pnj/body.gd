extends Node3D

func _ready():
	randomize()
	var animation_list = $AnimationPlayer.get_animation_list()
	var random_animation = animation_list[randi() % animation_list.size()]
	$AnimationPlayer.play(random_animation)
