extends Camera3D

var state = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()

func _physics_process(delta):
	if state == 0:
		await get_tree().create_timer(15).timeout
		$VBoxContainer/win.visible = false
		$VBoxContainer/credits.visible = true
		state = 1
	if state == 1:
		await get_tree().create_timer(20).timeout
		$Title.visible = true
