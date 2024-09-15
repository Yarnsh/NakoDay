extends SpotLight3D

@export var follow_node : Node3D
const flash_strength = 20.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_transform = follow_node.global_transform
	
	var rate = 20
	light_energy = lerpf(light_energy, 0.0, (rate * delta)*(rate * delta))

func flash():
	# TODO: check cooldown
	light_energy = flash_strength
	# TODO: flash sound, and save the picture

func _input(event):
	if event.is_action_pressed("Action"):
		flash()
