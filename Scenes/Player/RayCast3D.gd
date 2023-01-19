extends RayCast3D

@onready var prompt = $Prompt
@onready var highlight
@onready var donut_eaten = 0
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
				detected.interact()
				donut_eaten+=1
	elif donut_eaten==10:
		prompt.text = "BRAVO TU AS MANGÉ TOUS LES DONUTS WOW T'ES CHAUD !! \n Tu peux demander au dev d'ajouter ton nom a la liste des gens qui ont réussi, bien joué : \n"
		get_tree().paused = true
	else:
		if highlight != null:
			highlight.visible = false
