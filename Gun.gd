extends OmniLight3D

@export var shotgun_model : Node3D
@export var follow_node : Node3D
const flash_strength = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform = follow_node.global_transform
	
	var rate = 80 # TODO: make this less painful somehow
	light_energy = lerpf(light_energy, 0.0, (rate * delta)*(rate * delta))

func fire():
	# TODO: check cooldown
	light_energy = flash_strength
	shotgun_model.anim.play("fire_and_pump")
	# TODO: noise.play()
	# TODO: save the picture

func _input(event):
	if shotgun_model.visible and !shotgun_model.anim.is_playing() and event.is_action_pressed("Action"):
		fire()
