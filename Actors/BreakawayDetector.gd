extends Area3D

@onready var sound = $AudioStreamPlayer3D
@export var breakaway : StaticBody3D
@export var delay = 0
@export var particles : GPUParticles3D
@export var disable_thing : StaticBody3D
var breaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if breaking:
		delay -= delta * 1000
		if delay <= 0:
			sound.play()
			breakaway.breakaway()
			particles.emitting = true
			breaking = false

func _on_body_entered(body):
	breaking = true
	set_collision_mask_value(32, false)
	disable_thing.set_collision_layer_value(1, false)
