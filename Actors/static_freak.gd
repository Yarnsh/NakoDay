extends StaticBody3D

@onready var particles = $GPUParticles3D
@onready var model = $manquin

func destroy():
	model.hide()
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, false)
	particles.emitting = true
