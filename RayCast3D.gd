extends RayCast3D

@onready var prompt = $Prompt
@onready var highlight

# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()

		if detected is Interactable:
			prompt.text = detected.get_prompt()
			highlight = detected.get_node("highlight")
			highlight.visible = true
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
				
	else:
		if highlight != null:
			highlight.visible = false
