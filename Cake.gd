extends StaticBody3D

@onready var alive = $Alive
@onready var c1 = $Alive/Candle
@onready var c2 = $Alive/Candle2
@onready var c3 = $Alive/Candle3
@onready var c4 = $Alive/Candle4
@onready var sound = $AudioStreamPlayer3D
@onready var particles = $GPUParticles3D

func light():
	c1.light()
	c2.light()
	c3.light()
	c4.light()

func destroy():
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	sound.play()
	particles.emitting = true
	alive.hide()
	# TODO: cake splatting effect and some light effects for destroying candles
