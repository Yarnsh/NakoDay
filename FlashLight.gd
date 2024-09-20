extends SpotLight3D

@export var cam_model : Node3D
@export var follow_node : Node3D
const flash_strength = 20.0
var next_allowed = 0

@onready var noise = $FlashNoise

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_transform = follow_node.global_transform
	
	var rate = 20
	light_energy = lerpf(light_energy, 0.0, (rate * delta)*(rate * delta))

func flash():
	light_energy = flash_strength
	noise.play()
	next_allowed = Time.get_ticks_msec() + 2000
	# TODO: save the picture

func _input(event):
	if cam_model.visible and event.is_action_pressed("Action"):
		if Time.get_ticks_msec() >= next_allowed:
			flash()
	elif event.is_action_pressed("Aim"):
		cam_model.set_aimed(true)
	elif event.is_action_released("Aim"):
		cam_model.set_aimed(false)
