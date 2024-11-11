extends StaticBody3D

@onready var sound = $AudioStreamPlayer3D
@onready var p1 = $GPUParticles3D

func destroy():
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	sound.play()
	p1.emitting = true
	$wooden_table.hide()
